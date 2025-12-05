class MessagesController < ApplicationController
  skip_before_action :user_authenticate

  def create
    unless current_user.office.subscription_active?
      redirect_to subscriptions_index_path, alert: "サブスクリプションが有効ではないため、メッセージを送信できません。"
      return
    end
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
