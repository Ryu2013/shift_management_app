class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  skip_before_action :office_authenticate
  skip_before_action :user_authenticate

  def create
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    # .env または credentials から取得
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)

    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      head :bad_request
      return
    end

    Rails.logger.info "★Webhook受信: #{event.type}"

    case event.type

    # 1. 初回契約完了
    when "checkout.session.completed"
      session = event.data.object
      handle_checkout_session_completed(session)

    # 2. 毎月の支払い成功（更新）
    when "invoice.payment_succeeded"
      invoice = event.data.object
      handle_payment_succeeded(invoice)

    # 3. 支払い失敗
    when "invoice.payment_failed"
      invoice = event.data.object
      handle_payment_failed(invoice)

    # 4. ステータス変更・解約
    when "customer.subscription.updated", "customer.subscription.deleted"
      subscription = event.data.object
      handle_subscription_updated(subscription)
    end

    head :ok
  end

  private

  # ----------------------------------------------------------------
  # 1. 初回登録時の処理
  # ----------------------------------------------------------------
  def handle_checkout_session_completed(session)
    office_id = session.metadata.office_id
    office = Office.find_by(id: office_id)

    unless office
      Rails.logger.error "★Officeが見つかりません: ID #{office_id}"
      return
    end

    stripe_sub = Stripe::Subscription.retrieve(session.subscription)
    period_end = stripe_sub.items.data[0].current_period_end
    is_canceling = stripe_sub.cancel_at_period_end || stripe_sub.cancel_at.present?

    # ★修正: .current_period_end -> [:current_period_end] に変更
    office.update!(
      stripe_customer_id:     session.customer,
      stripe_subscription_id: stripe_sub.id,
      subscription_status:    stripe_sub.status,
      current_period_end:     Time.at(period_end),
      cancel_at_period_end:   is_canceling
    )
    Rails.logger.info "★初回契約完了: Office #{office.id}"
  end

  # ----------------------------------------------------------------
  # 2. 毎月の更新（支払い成功）
  # ----------------------------------------------------------------
  def handle_payment_succeeded(invoice)
    office = Office.find_by(stripe_subscription_id: invoice.subscription)
    return unless office

    stripe_sub = Stripe::Subscription.retrieve(invoice.subscription)
    period_end = stripe_sub.items.data[0].current_period_end
    is_canceling = stripe_sub.cancel_at_period_end || stripe_sub.cancel_at.present?
    office.update!(
      subscription_status: stripe_sub.status,
      current_period_end:  Time.at(period_end),
      cancel_at_period_end:   is_canceling
    )
    Rails.logger.info "★更新完了: Office #{office.id}"
  end

  # ... (他のメソッドはそのまま) ...

  # ----------------------------------------------------------------
  # 4. ステータス変更・解約
  # ----------------------------------------------------------------
  def handle_subscription_updated(stripe_sub)
    office = Office.find_by(stripe_subscription_id: stripe_sub.id)
    return unless office
    period_end = stripe_sub.items.data[0].current_period_end
    is_canceling = stripe_sub.cancel_at_period_end || stripe_sub.cancel_at.present?
    office.update!(
      subscription_status: stripe_sub[:status],
      current_period_end:  Time.at(period_end),
      cancel_at_period_end:   is_canceling
    )
    Rails.logger.info "★ステータス変更: Office #{office.id}"
  end


  # ----------------------------------------------------------------
  # 3. 支払い失敗（これを追加するのを忘れずに！）
  # ----------------------------------------------------------------
  def handle_payment_failed(invoice)
    office = Office.find_by(stripe_subscription_id: invoice.subscription)
    return unless office

    stripe_sub = Stripe::Subscription.retrieve(invoice.subscription)

    # ステータスを更新（past_dueなど）
    office.update!(subscription_status: stripe_sub.status)
    Rails.logger.warn "★支払い失敗: Office #{office.id} (Status: #{stripe_sub.status})"
  end
end
