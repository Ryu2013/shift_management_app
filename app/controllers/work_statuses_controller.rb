class WorkStatusesController < ApplicationController
  before_action :set_team
  before_action :set_client

  def index
    @date  = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @clients = @team.clients.order(:id)

    @shifts = @office.shifts
      .joins(:client)
      .where(date: @date, clients: { team_id: @team.id })
      .includes(:user, :client)
      .order("clients.name ASC, start_time ASC")
      .group_by(&:client_id)

    all_shifts = @shifts.values.flatten

    @work_count     = all_shifts.count { |s| s.work_status == "work" }
    @not_work_count = all_shifts.count { |s| s.work_status == "not_work" }
  end
end
