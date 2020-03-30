class InstantMessageChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    conversation = Conversation.find(params[:id])
    stream_for conversation
  end

  def send_instant(msg)
    conversation = Conversation.find(params[:id])
    self.broadcast_to(conversation, msg['data'])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
