class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @clients = @office.clients.all
  end

  def show
  end

  def new
    @client = @office.clients.new
    @teams = @office.teams.all
  end

  def edit
    @teams = @office.teams.all
  end

  def create
    @client = @office.clients.new(client_params)
    if @client.save
      redirect_to clients_path, notice: "クライアントを作成しました。"
    else
      @teams = @office.teams.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      redirect_to clients_path, notice: "クライアントを更新しました。", status: :see_other
    else
      @teams = @office.teams.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: "クライアントを削除しました。", status: :see_other
  end

  private

  def set_client
    @client = @office.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:team_id, :medical_care, :name, :email, :address, :disease, :public_token, :note)
  end
end
