class MessagesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :user_authenticate

  def create
    @room = @office.rooms.find(params[:room_id])
    @message = @room.messages.build(message_params)
    @message.user = current_user
    @message.save
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
