# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
   prepend_before_action :set_office_from_session, only: [ :new, :create ]
  
  private
  # New,Create時に,Currentをセット。session[:office_id]がなければリダイレクト
  def set_office_from_session
    @office = Office.find_by(id: session[:office_id])
    redirect_to root_path, alert: "事業所情報が不明です" unless @office
  end

  # 登録用ストロングパラメータ（permit + office_id をサーバ側で付与）
  def sign_up_params
    params.require(:user).permit(
      :name, :address, :pref_per_week, :commute,
      :email, :password, :password_confirmation, :team_id
    ).merge(office_id: @office.id)
  end

  # 編集画面用ストロングパラメータ
  def account_update_params
    params.require(:user).permit(
      :name, :address, :pref_per_week, :commute, :team_id,
      :email, :password, :password_confirmation, :current_password
    )
  end
end
