class ShiftsController < ApplicationController
  before_action :set_shift, only: %i[ edit update destroy ]
  before_action :set_team
  before_action :set_client

  def index
    @teams = @office.teams
    @clients = @team.clients

    @today = Date.today
    @first_day = @today.beginning_of_month
    @last_day  = @today.end_of_month

    shifts = @client.shifts

    if params[:date].present?
      date = Date.strptime(params[:date], "%Y-%m")
      shifts = shifts.where(date: date.beginning_of_month..date.end_of_month)
      @date = date.strftime("%m月")
    else
      @date = Date.current.strftime("%m月")
      shifts = shifts.where(date: Date.current.beginning_of_month..Date.current.end_of_month)
    end

    @shifts_by_date = shifts.group_by { |shift| shift.date }
  end

  def new
    @shift = @office.shifts.new(client_id: params[:client_id])
  end

  def edit
  end

  def create
    @shift = @office.shifts.build(shift_params)
    if @shift.save
      redirect_to team_client_shifts_path(@team, @client), notice: "シフトを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @shift.update(shift_params)
      redirect_to team_client_shifts_path(@team, @client), notice: "シフトを更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shift.destroy!
    redirect_to team_client_shifts_path(@team, @client), notice: "シフトを削除しました。", status: :see_other
  end

  private

  def set_shift
    @shift = @office.shifts.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:client_id, :shift_type, :slots, :note, :date, :start_time, :end_time)
  end
end
