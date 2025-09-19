class ContactStatusesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_employee_context
  before_action :ensure_office_presence!
  before_action :ensure_correct_office_slug!

  def index
    @contact_statuses = @office.contact_statuses.includes(:employee, :shift_member)
  end
end
