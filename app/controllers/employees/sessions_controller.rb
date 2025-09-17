module Employees
  class SessionsController < Devise::SessionsController
    before_action :load_office_from_slug, only: :new

    private

    def load_office_from_slug
      slug = params[:office_slug]
      return if slug.blank?

      @office = Office.find_by(slug: slug)
      return if @office.present?

      redirect_to new_employee_session_path, alert: "指定された事業所が見つかりません。"
    end
  end
end
