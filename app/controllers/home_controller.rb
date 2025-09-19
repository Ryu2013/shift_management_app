class HomeController < ApplicationController
  before_action :redirect_if_signed_in, only: :index

  def index
  end

  private
  
  #ログイン済みand事業所設定済みなら事業所のシフト画面へリダイレクト
  def redirect_if_signed_in
    return unless employee_signed_in?

    office = current_employee.office
    return if office.blank? # 事業所未設定ならそのまま表示

    redirect_to office_shift_path(office_slug: office.slug)
  end
end
