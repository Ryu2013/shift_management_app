class UserNeedsController < ApplicationController
  before_action :set_user_need, only: %i[ show edit update destroy ]

  # GET /user_needs or /user_needs.json
  def index
    @user_needs = UserNeed.all
  end

  # GET /user_needs/1 or /user_needs/1.json
  def show
  end

  # GET /user_needs/new
  def new
    @user_need = UserNeed.new
  end

  # GET /user_needs/1/edit
  def edit
  end

  # POST /user_needs or /user_needs.json
  def create
    @user_need = UserNeed.new(user_need_params)

    respond_to do |format|
      if @user_need.save
        format.html { redirect_to @user_need, notice: "ユーザー希望を作成しました。" }
        format.json { render :show, status: :created, location: @user_need }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_need.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_needs/1 or /user_needs/1.json
  def update
    respond_to do |format|
      if @user_need.update(user_need_params)
        format.html { redirect_to @user_need, notice: "ユーザー希望を更新しました。", status: :see_other }
        format.json { render :show, status: :ok, location: @user_need }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_need.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_needs/1 or /user_needs/1.json
  def destroy
    @user_need.destroy!

    respond_to do |format|
      format.html { redirect_to user_needs_path, notice: "ユーザー希望を削除しました。", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_need
      @user_need = UserNeed.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_need_params
      params.require(:user_need).permit(:office_id, :user_id, :week, :start_time, :end_time)
    end
end
