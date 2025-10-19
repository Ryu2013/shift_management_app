# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_office_from_session, only: [ :new, :create ]

  private
  # session から事業所情報を取得しておく
  def set_office_from_session
    @office = Office.find_by(id: session[:office_id])
    redirect_to root_path, alert: "事業所情報が不明です" unless @office
  end

  # サインイン用ストロングパラメータ（permit + office_id をサーバ側で付与）
  def sign_up_params
    params.require(:user).permit(
      :name, :address, :pref_per_week, :commute,
      :email, :password, :password_confirmation
    ).merge(office_id: @office.id)
  end

  # 編集画面で追加属性を許可したいならこちらも
  def account_update_params
    params.require(:user).permit(
      :name, :address, :pref_per_week, :commute,
      :email, :password, :password_confirmation, :current_password
    )
  end
end
