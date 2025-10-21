class ClientsController < ApplicationController
  before_action :set_team
  before_action :set_client, only: %i[index edit update destroy]

  def index
    @clients = @team.clients.all
  end

  def new
    @client = @team.clients.new
    @teams = @office.teams.all
  end

  def edit
    @teams = @office.teams.all
  end

  def create
    @client = @office.clients.new(client_params)
    if @client.save
      redirect_to team_clients_path(@team), notice: "クライアントを作成しました。"
    else
      @teams = @office.teams.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      redirect_to team_clients_path(@team), notice: "クライアントを更新しました。", status: :see_other
    else
      @teams = @office.teams.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to team_clients_path(@team), notice: "クライアントを削除しました。", status: :see_other
  end

  private


  def client_params
    params.require(:client).permit(:team_id, :medical_care, :name, :email, :address, :disease, :public_token, :note)
  end
end
