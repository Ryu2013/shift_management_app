class UserNeedsController < ApplicationController
  before_action :set_team
  before_action :set_client
  before_action :set_user
  before_action :set_user_need, only: %i[index show edit update destroy]

  def index
    @user_needs = @user.user_needs.order(:week, :start_time).group_by(&:week)
    @user_need = @user.user_needs.build
  end

  def show
  end

  def new
    @user_need = @user.user_needs.build
  end

  def edit
  end

  def create
    @user_need = @user.user_needs.build(user_need_params)

    if @user_need.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @user_need, notice: "ユーザー希望を作成しました。" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @user_need.update(user_need_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @user_need, notice: "ユーザー希望を更新しました。", status: :see_other }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_need.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_needs_path, notice: "ユーザー希望を削除しました。", status: :see_other }
    end
  end

  private

  def set_user
    @user = @team.users.find(params[:user_id])
  end

  def set_user_need
    @user_need = @user.user_needs.find(params[:id])
  end

  def user_need_params
    params.require(:user_need).permit(:office_id, :user_id, :week, :start_time, :end_time)
  end
end
