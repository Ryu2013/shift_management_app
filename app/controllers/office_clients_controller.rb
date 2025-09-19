class OfficeClientsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_employee_context
  before_action :ensure_office_presence!
  before_action :ensure_correct_office_slug!

  def index
    @clients = @office.clients.order(:name)
  end
end
