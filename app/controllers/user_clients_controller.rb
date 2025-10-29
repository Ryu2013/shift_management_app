class UserClientsController < ApplicationController
  before_action :office_authenticate
  before_action :set_team
  before_action :set_client
  before_action :set_user_client, only: %i[ show edit update destroy ]

  def index
    @user_clients = userClient.all
  end

  def show
  end

  def new
    @user_client = userClient.new
  end

  def edit
  end

  def create
    @user_client = userClient.new(user_client_params)

    respond_to do |format|
      if @user_client.save
        format.html { redirect_to @user_client, notice: "ユーザークライアントを作成しました。" }
        format.json { render :show, status: :created, location: @user_client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_client.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user_client.update(user_client_params)
        format.html { redirect_to @user_client, notice: "ユーザークライアントを更新しました。", status: :see_other }
        format.json { render :show, status: :ok, location: @user_client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_client.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_client.destroy!

    respond_to do |format|
      format.html { redirect_to user_clients_path, notice: "ユーザークライアントを削除しました。", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_user_client
      @user_client = userClient.find(params[:id])
    end

    def user_client_params
      params.require(:user_client).permit(:office_id, :user_id, :client_id, :note)
    end
end
