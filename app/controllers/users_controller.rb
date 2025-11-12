# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :set_team
  before_action :set_client
  before_action :set_user, only: [ :edit, :update ]

  def index
    @teams = @office.teams
    @users = @team.users.order(:id)
  end

  def edit
    @teams = @office.teams
    @user_needs = @user.user_needs.order(:week, :start_time).group_by(&:week)
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "従業員情報を更新しました。", status: :see_other
    else
      @teams = @office.teams
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = @office.users.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :address, :pref_per_week, :commute, :team_id)
    end
end
