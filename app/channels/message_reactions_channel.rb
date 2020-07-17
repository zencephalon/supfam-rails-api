class MessageReactionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_for "#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
