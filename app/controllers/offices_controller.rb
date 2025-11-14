class OfficesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :office_authenticate
  skip_before_action :user_authenticate

  def new
    @office = Office.new
    @office.teams.build
  end

  def create
    @office = Office.new(office_params)
    if @office.save
      session[:office_id] = @office.id
      team = @office.teams.first
      redirect_to new_user_registration_path(team_id: team.id), notice: "オフィスと部署を作成しました。", status: :see_other
    else
      flash.now[:alert] = "部署の作成に失敗しました。もう一度お試しください。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def office_params
    params.require(:office).permit(:name, teams_attributes: [ :name ])
  end
end
