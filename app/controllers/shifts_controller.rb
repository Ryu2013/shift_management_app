class ShiftsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_employee_context
  before_action :ensure_office_presence!, only: :index
  before_action :ensure_correct_office_slug!, only: :index

  def index
  end

  def create
  end

  def destroy
  end
end
