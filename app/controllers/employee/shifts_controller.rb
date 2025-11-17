class Employee::ShiftsController < ApplicationController
  skip_before_action :user_authenticate

  def index
    @date = params[:date].present? ? Date.strptime(params[:date], "%Y-%m") : Date.current
    @today = Date.today
    @first_day = @date.beginning_of_month
    @last_day  = @date.end_of_month

    @shifts = current_user.shifts.scope_month(@date).group_by { |shift| shift.date }
    @date_view = @date.strftime("%m月")
    @today_shift = current_user.shifts.find_by(date: @today)
  end

  def update
    @shift = current_user.shifts.find(params[:id])
    if @shift.update(shift_params)
      redirect_to employee_shifts_path, notice: "シフトを更新しました。"
    else
      @date = Date.current
      @today = Date.today
      @first_day = @date.beginning_of_month
      @last_day  = @date.end_of_month
      @shifts = current_user.shifts.scope_month(@date).group_by { |shift| shift.date }
      @date_view = @date.strftime("%m月")
      @today_shift = current_user.shifts.find_by(date: @today)
      flash.now[:alert] = "シフトの更新に失敗しました。"
      render :index, status: :unprocessable_entity
    end
  end

  private
  def shift_params
    params.require(:shift).permit(:work_status)
  end
end
