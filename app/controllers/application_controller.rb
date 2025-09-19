class ApplicationController < ActionController::Base
  private

  def set_employee_context
    @employee = current_employee
    @office = @employee&.office
  end

  def ensure_office_presence!
    return if @office.present?

    sign_out current_employee
    flash[:alert] = '所属事業所が確認できません。ログインし直してください。'
    redirect_to root_path and return
  end

  def ensure_correct_office_slug!
    return unless @office

    slug = params[:office_slug]
    return if slug.present? && slug == @office.slug

    sign_out current_employee
    flash[:alert] = '所属事業所以外のページへアクセスしようとしたためログアウトしました。正しいログインページからログインしてください。'
    redirect_to office_sign_in_path(office_slug: @office.slug) and return
  end
end
