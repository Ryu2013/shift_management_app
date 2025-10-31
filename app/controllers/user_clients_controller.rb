class UserClientsController < ApplicationController
  before_action :office_authenticate
  before_action :set_team
  before_action :set_client
  before_action :set_user_client, only: %i[ destroy ]

  def new
    @user_client = @client.user_clients.build
    @user_clients = @client&.user_clients
    @users = @team.users
  end

  def create
    @user_client = @client.user_clients.build(user_client_params)

    respond_to do |format|
      if @user_client.save
        format.html { redirect_to new_team_client_user_client_path(@team, @client), notice: "ユーザークライアントを作成しました。" }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def destroy
    @user_client.destroy!

    respond_to do |format|
      format.html { redirect_to user_clients_path, notice: "ユーザークライアントを削除しました。", status: :see_other }
      format.turbo_stream
    end
  end

  private
    def set_user_client
      @user_client = @client.user_clients.find(params[:id])
    end

    def user_client_params
      params.require(:user_client).permit(:office_id, :user_id, :client_id, :note)
    end
end
