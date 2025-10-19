class UserClientsController < ApplicationController
  before_action :set_user_client, only: %i[ show edit update destroy ]

  # GET /user_clients or /user_clients.json
  def index
    @user_clients = userClient.all
  end

  # GET /user_clients/1 or /user_clients/1.json
  def show
  end

  # GET /user_clients/new
  def new
    @user_client = userClient.new
  end

  # GET /user_clients/1/edit
  def edit
  end

  # POST /user_clients or /user_clients.json
  def create
    @user_client = userClient.new(user_client_params)

    respond_to do |format|
      if @user_client.save
        format.html { redirect_to @user_client, notice: "user client was successfully created." }
        format.json { render :show, status: :created, location: @user_client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_clients/1 or /user_clients/1.json
  def update
    respond_to do |format|
      if @user_client.update(user_client_params)
        format.html { redirect_to @user_client, notice: "user client was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user_client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_clients/1 or /user_clients/1.json
  def destroy
    @user_client.destroy!

    respond_to do |format|
      format.html { redirect_to user_clients_path, notice: "user client was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_client
      @user_client = userClient.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_client_params
      params.require(:user_client).permit(:office_id, :user_id, :client_id, :note)
    end
end
