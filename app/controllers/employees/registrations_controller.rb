module Employees
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :pending_office_name])
    end

    def after_inactive_sign_up_path_for(_resource)
      flash[:notice] = '確認メールを送信しました。メール内のリンクを開いて登録を完了してください。'
      new_employee_registration_path
    end
  end
end
