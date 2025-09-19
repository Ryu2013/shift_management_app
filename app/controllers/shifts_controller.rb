class ShiftsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_employee
  before_action :ensure_office_presence!, only: :index
  before_action :ensure_correct_slug!, only: :index

  def index
  end

  def create
  end

  def destroy
  end

  private

  def set_employee
    @employee = current_employee
    @office = @employee&.office
  end
  # 事業所が未登録の場合はログアウトしてトップへ戻す
  def ensure_office_presence!
    return if @office.present?

    sign_out current_employee
    flash[:alert] = '所属事業所が確認できません。ログインし直してください。'
    redirect_to root_path and return
  end

  # スラッグが欠けている、または別事業所のURLなら正しいログインページへ誘導
  def ensure_correct_slug!

    slug = params[:office_slug]
    return if slug.present? && slug == @office.slug

    sign_out current_employee
    flash[:alert] = '所属事業所以外のページへアクセスしようとしたためログアウトしました。正しいログインページからログインしてください。'
    redirect_to office_sign_in_path(office_slug: @office.slug) and return
  end
end
