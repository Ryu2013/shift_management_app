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

    @date = params[:date].present? ? Date.strptime(params[:date], "%Y-%m") : Date.current
    @shifts = @client.shifts.scope_month(@date).group_by { |shift| shift.date }
    @date_view = @date.strftime("%m月")
  end

  def new
    @shift = @office.shifts.new(client_id: params[:client_id])
    @date = params[:date]
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

  def generate_monthly_shifts
    month = Date.strptime(params[:date], "%Y-%m")
    result = ::Shifts::MonthlyGenerator.new(client: @client, month: month, office: @office).call
    redirect_to team_client_shifts_path(@team, @client, date: month.strftime("%Y-%m")), notice: "シフトを#{result[:created]}件作成しました。"
  end


  private

  def set_shift
    @shift = @office.shifts.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:client_id, :shift_type, :slots, :note, :date, :start_time, :end_time)
  end
end
