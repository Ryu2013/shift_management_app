class OfficesController < ApplicationController
  before_action :set_office, only: %i[show edit update destroy]

  def show
  end

  def new
    @office = Office.new
  end

  def edit
  end

  def create
    @office = Office.new(office_params)
    if @office.save
      session[:office_id] = @office.id
      redirect_to new_user_registration_path, notice: "オフィスを作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @office.update(office_params)
      redirect_to @office, notice: "オフィスを更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  @office.destroy!
  redirect_to new_office_path, notice: "オフィスを削除しました。", status: :see_other
  end

  private

  def set_office
    @office = Office.find(params[:id])
  end

  def office_params
    params.require(:office).permit(:name)
  end
end
