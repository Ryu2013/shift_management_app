class StripeSubscriptionService
  attr_reader :office

  def initialize(office)
    @office = office
  end

  def create_checkout_session(success_url:, cancel_url:)
    create_customer unless office.stripe_customer_id.present?

    price_id = ENV["STRIPE_METERED_PRICE_ID"]

    session = Stripe::Checkout::Session.create(
      customer: office.stripe_customer_id,
      mode: "subscription",
      line_items: [ {
        price: price_id
        # 従量課金(Metered)の場合は quantity 指定は不要
      } ],
      success_url: success_url,
      cancel_url: cancel_url,

      # セッション（レジ通過記録）へのメタデータ
      metadata: {
        office_id: office.id
      },

      # ★推奨: サブスクリプション（契約書）自体へのメタデータ
      # これを入れておくと、更新時(invoice.payment_succeeded)のWebhookでも office_id が参照できて便利です
      subscription_data: {
        metadata: {
          office_id: office.id
        }
      }
    )

    session.url
  end

  private

  # Stripeに顧客を作成し、Officeに保存する
  def create_customer
    customer = Stripe::Customer.create(
      email: office.users.first&.email, # 代表者のメールアドレスなどを想定
      name: office.name,
      metadata: {
        office_id: office.id
      }
    )

    office.update!(stripe_customer_id: customer.id)
  end
end
