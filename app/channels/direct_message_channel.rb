class DirectMessageChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    conversation = Conversation.dmWith(current_user.id, params[:with_user_id])
    stream_for conversation
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
