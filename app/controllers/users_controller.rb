# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :set_team
  before_action :set_client

  def index
    @teams = @office.teams

    @users = @team.users.order(:id)
  end
end
