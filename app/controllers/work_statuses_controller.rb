class WorkStatusesController < ApplicationController
  before_action :office_authenticate
  before_action :set_team

  def index
    @date  = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @today = @date

    @shifts = @office.shifts
      .joins(:client)
      .where(date: @today, clients: { team_id: @team.id })
      .includes(:user, :client)
      .order('clients.name ASC, start_time ASC')

    @work_count     = @shifts.where(work_status: :work).count
    @not_work_count = @shifts.where(work_status: :not_work).count
  end
end
