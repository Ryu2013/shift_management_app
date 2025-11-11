class ShiftsController < ApplicationController
  before_action :set_shift, only: %i[ edit update destroy ]
  before_action :set_team
  before_action :set_client

  def index
    @teams = @office.teams
    @clients = @team.clients
    @date = params[:date].present? ? Date.strptime(params[:date], "%Y-%m") : Date.current
    @today = Date.today
    @first_day = @date.beginning_of_month
    @last_day  = @date.end_of_month

    @shifts = @client.shifts.scope_month(@date).group_by { |shift| shift.date }
    @date_view = @date.strftime("%m月")
    @user_clients = @client.users
  end

  def new
    @shift = @office.shifts.new(client_id: params[:client_id])
    @date = params[:date]
    @user_clients = @client.users
  end

  def edit
    @user_clients = @client.users
  end

  def create
    @shift = @office.shifts.build(shift_params)
    if @shift.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to team_client_shifts_path(@team, @client), notice: "シフトを作成しました。" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @shift.update(shift_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to team_client_shifts_path(@team, @client), notice: "シフトを更新しました。", status: :see_other }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shift.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to team_client_shifts_path(@team, @client), notice: "シフトを削除しました。", status: :see_other }
    end
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
    params.require(:shift).permit(:user_id, :client_id, :shift_type, :slots, :note, :date, :start_time, :end_time, :work_status)
  end
end
