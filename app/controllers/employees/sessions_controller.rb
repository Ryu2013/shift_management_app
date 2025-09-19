module Employees
  class SessionsController < Devise::SessionsController
    before_action :load_office_from_slug, only: [:new, :create]

    private
    # ログイン後にresourceにemployeeが入るので、そこから事業所のslugを取得してリダイレクト先を決定する。
    def after_sign_in_path_for(resource)
      if resource.office&.slug.present?
        office_shift_path(office_slug: resource.office.slug)
      else
        flash[:alert] = '所属事業所が設定されていません。管理者に問い合わせてください。'
        new_employee_session_path
      end
    end
    
    ##ログイン前にURLに事業所があるか？office内に存在しているかを確認
    def load_office_from_slug
      slug = params[:office_slug]
      return if slug.blank?

      @office = Office.find_by(slug: slug)
      return if @office.present?

      redirect_to new_employee_session_path, alert: "指定された事業所が見つかりません。"
    end
  end
end
