class ShiftsController < ApplicationController
  before_action :set_shift, only: %i[ show edit update destroy ]

  def index
    @teams = @office.teams
    @clients = @office.clients
    @shifts = @office.shifts

    if params[:team_id].present?
      team = @teams.find_by(id: params[:team_id])
    else
      team = @teams.order(:id).first
    end

    if params[:client_id].present?
      client = @clients.find_by(id: params[:client_id])
    else
      client = team.clients.order(:id).first
    end
    @clients = team.clients
    @shifts = client.shifts
  end

  def show
  end

  def new
    @shift = @office.shifts.new
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      redirect_to @shift, notice: "Shift was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @shift.update(shift_params)
      redirect_to @shift, notice: "Shift was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shift.destroy!
    redirect_to shifts_path, notice: "Shift was successfully destroyed.", status: :see_other
  end

  private

  def set_shift
    @shift = @office.shifts.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:client_id, :shift_type, :slots, :note, :date)
  end
end
