class ClientNeedsController < ApplicationController
  before_action :set_team
  before_action :set_client
  before_action :set_client_need, only: %i[ show edit update destroy ]

  def index
    @client_needs = @client.client_needs.all
    @client_need = @client.client_needs.build
  end

  def show
  end

  def new
    @client_need = @client.client_needs.build
  end

  def edit
  end

  def create
  @client_need = @client.client_needs.build(client_need_params)
    if @client_need.save
      respond_to do |format|
      format.turbo_stream
      format.html { redirect_to edit_team_client_path(@team, @client), notice: "クライアント希望を作成しました。" }
      end
    else
      respond_to do |format|
      format.turbo_stream { render :new, status: :unprocessable_entity }
      format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @client_need.update(client_need_params)
     respond_to do |format|
     format.turbo_stream
     format.html { redirect_to edit_team_client_path(@team, @client), notice: "クライアント希望を更新しました。", status: :see_other }
     end
    else
      respond_to do |format|
      format.turbo_stream { render :edit, status: :unprocessable_entity }
      format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client_need.destroy!
    respond_to do |format|
    format.turbo_stream
    format.html { redirect_to edit_team_client_path(@team, @client), notice: "クライアント希望を削除しました。", status: :see_other }
    end
  end

  private
    def set_client_need
      @client_need = @client.client_needs.find(params[:id])
    end

    def client_need_params
      params.require(:client_need).permit(:office_id, :client_id, :week, :shift_type, :start_time, :end_time, :slots)
    end
end
