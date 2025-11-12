class ClientNeedsController < ApplicationController
  before_action :set_team
  before_action :set_client
  before_action :set_client_need, only: %i[edit destroy ]

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
      format.html { redirect_to edit_team_client_path(@team, @client), notice: "シフトを登録しました" }
      end
    else
      respond_to do |format|
      format.turbo_stream { render :new, status: :unprocessable_entity }
      format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client_need.destroy!
    respond_to do |format|
    format.turbo_stream
    format.html { redirect_to edit_team_client_path(@team, @client), notice: "シフトを削除しました。", status: :see_other }
    end
  end

  private
    def set_client_need
      @client_need = @client.client_needs.find(params[:id])
    end

    def client_need_params
      params.require(:client_need).permit(:week, :shift_type, :start_time, :end_time, :slots)
    end
end
