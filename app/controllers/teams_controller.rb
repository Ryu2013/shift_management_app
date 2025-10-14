class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]

  def index
    @teams = @office.teams.all
  end

  def show
  end

  def new
    @team = @office.teams.new
  end

  def edit
  end

  def create
    @team = @office.teams.new(team_params)
    if @team.save
      redirect_to new_client_path(team_id: @team.id), notice: "チームを作成しました。次にクライアントを登録してください。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: "Team was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy!
    redirect_to teams_path, notice: "Team was successfully destroyed.", status: :see_other
  end

  private

  def set_team
    @team = @office.teams.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name)
  end
end
