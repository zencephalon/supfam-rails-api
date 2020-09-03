# typed: true
class MessageChannel < ApplicationCable::Channel
  def subscribed
    reject unless current_user.conversation_memberships.where(conversation_id: params[:id]).first

    stream_for params[:id].to_s
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
