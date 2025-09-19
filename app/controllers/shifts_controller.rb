class ShiftsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_employee
  before_action :ensure_office_presence!, only: :index
  before_action :ensure_correct_slug!, only: :index

  def index
  end

  def create
  end

  def destroy
  end

  private

  def set_employee
    @employee = current_employee
    @office = @employee&.office
  end

  def ensure_office_presence!
    return if @office.present?

    redirect_to root_path, alert: '事業所がまだ設定されていません。'
  end

  def ensure_correct_slug!
    return unless @office

    requested_slug = params[:office_slug]
    return if requested_slug.present? && requested_slug == @office.slug

    redirect_to office_shift_path(office_slug: @office.slug)
  end
end
