class InstantMessageChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "instant:#{params[:id]}"
  end

  def send_instant(msg)
    self.broadcast("instant:#{params[:id]}", msg['data'])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
