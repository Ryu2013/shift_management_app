# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @teams = @office.teams

    if params[:team_id].present?
      @team = @teams.find_by(id: params[:team_id])
    else
      @team = @teams.order(:id).first
    end

    @users = @team.users.order(:id)
  end
end
