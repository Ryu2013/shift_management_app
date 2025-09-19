class OfficeEmployeesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_employee_context
  before_action :ensure_office_presence!
  before_action :ensure_correct_office_slug!
  before_action :set_managed_employee, only: [:edit, :update]

  def index
    @employees = @office.employees.order(:name)
  end

  def edit
    build_additional_employee_need
  end

  def update
    if @managed_employee.update(employee_params)
      redirect_to office_employees_path(office_slug: @office.slug), notice: '従業員情報を更新しました。'
    else
      build_additional_employee_need
      flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_managed_employee
    @managed_employee = @office.employees.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :address, :commute, :note, :role, :pref_days,
                                     employee_needs_attributes: [:id, :week, :start_time, :end_time, :_destroy])
  end

  def build_additional_employee_need
    @managed_employee.employee_needs.build(office: @office) unless @managed_employee.employee_needs.any?(&:new_record?)
  end
end
