module Employees
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :pending_office_name])
    end

    def after_inactive_sign_up_path_for(_resource)
      new_employee_session_path
    end
  end
end
