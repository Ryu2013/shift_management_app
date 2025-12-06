class RoomsController < ApplicationController
  skip_before_action :user_authenticate
  before_action :set_room, only: %i[show destroy]

  def index
    if current_user.admin?
      @team = @office.teams.joins(:clients).distinct.order(:id).first
      @client = @team.clients.order(:id).first
    end
    @rooms = @office.rooms.joins(:entries).where(entries: { user_id: current_user.id })
  end

  def show
    @messages = @room.messages
    @message = @room.messages.new
  end

  def new
    if current_user.admin?
      @team = @office.teams.joins(:clients).distinct.order(:id).first
      @client = @team.clients.order(:id).first
    end
    @users = @office.users.where.not(id: current_user.id).order(:id)
  end

  def create
    user = @office.users.find(params[:user_id])
    rooms = current_user.rooms.where(office: @office) & user.rooms.where(office: @office)
    @room = rooms.first

    unless @room
      @room = @office.rooms.create
      Entry.create(user: current_user, room: @room, office: @office)
      Entry.create(user: user, room: @room, office: @office)
    end

    redirect_to @room
  end

  def destroy
    @room.destroy!
    redirect_to rooms_path, notice: "チャットを削除しました。", status: :see_other
  end

  private

  def set_room
    @room = current_user.rooms.where(rooms: { office_id: @office.id }).find_by(id: params[:id])
    unless @room
      redirect_to rooms_path, alert: "チャットへの参加者のみアクセスできます。" and return
    end
  end
end
