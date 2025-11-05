class Employee::ShiftsController < ApplicationController
  before_action :office_authenticate
  before_action :set_team
  before_action :set_client

  def index
    @teams = @office.teams
    @clients = @team.clients
    @date = params[:date].present? ? Date.strptime(params[:date], "%Y-%m") : Date.current
    @today = Date.today
    @first_day = @date.beginning_of_month
    @last_day  = @date.end_of_month

    @shifts = current_user.shifts.scope_month(@date).group_by { |shift| shift.date }
    @date_view = @date.strftime("%m月")
    @user_clients = @client.users
  end
end

