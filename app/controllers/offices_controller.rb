class OfficesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]
  skip_before_action :office_authenticate, only: %i[new create]


  def show
  end

  def new
    @office = Office.new
    @office.teams.build
  end

  def edit
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

  def update
    if @office.update(office_params)
      redirect_to @office, notice: "オフィスを更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  @office.destroy!
  redirect_to new_office_path, notice: "オフィスを削除しました。", status: :see_other
  end

  private

  def office_params
    params.require(:office).permit(:name, teams_attributes: [:name])
  end
end
