class HomeController < ApplicationController
  before_action :logout_if_signed_in, only: :index, if: :employee_signed_in?

  def index
  end

  private
  
  #ログイン済みで何らかの方法でhomeに来た場合ログアウト
  def logout_if_signed_in
    sign_out(current_employee) 
    flash[:alert] = '未ログインページにアクセスした為ログアウトしました。' 
  end
end
