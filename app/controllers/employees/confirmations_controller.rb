module Employees
  class ConfirmationsController < Devise::ConfirmationsController
    protected
    # メール確認URLクリック時 従業員のオフィスが登録済みならログインページへ、それ以外は既定の遷移
    def after_confirmation_path_for(resource_name, resource)
      office = resource.office
      if office.present?
        office_sign_in_path(office_slug: office.slug)
      else
        super
      end
    end
  end
end
