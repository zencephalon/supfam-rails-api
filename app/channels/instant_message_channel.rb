class InstantMessageChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_for "instant:#{params[:id]}"
  end

  def send_instant(msg)
    puts '=========='
    puts msg
    self.broadcast_to("instant:#{params[:id]}", msg['data'])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
