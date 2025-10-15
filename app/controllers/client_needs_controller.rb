class ClientNeedsController < ApplicationController
  before_action :set_client_need, only: %i[ show edit update destroy ]

  # GET /client_needs or /client_needs.json
  def index
    @client_needs = ClientNeed.all
  end

  # GET /client_needs/1 or /client_needs/1.json
  def show
  end

  # GET /client_needs/new
  def new
    @client_need = ClientNeed.new
  end

  # GET /client_needs/1/edit
  def edit
  end

  # POST /client_needs or /client_needs.json
  def create
    @client_need = ClientNeed.new(client_need_params)

    respond_to do |format|
      if @client_need.save
        format.html { redirect_to @client_need, notice: "Client need was successfully created." }
        format.json { render :show, status: :created, location: @client_need }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client_need.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /client_needs/1 or /client_needs/1.json
  def update
    respond_to do |format|
      if @client_need.update(client_need_params)
        format.html { redirect_to @client_need, notice: "Client need was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @client_need }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client_need.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_needs/1 or /client_needs/1.json
  def destroy
    @client_need.destroy!

    respond_to do |format|
      format.html { redirect_to client_needs_path, notice: "Client need was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client_need
      @client_need = ClientNeed.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_need_params
      params.require(:client_need).permit(:office_id, :client_id, :week, :type, :start_time, :end_time, :slots)
    end
end
