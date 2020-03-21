class SeenChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update_seen(msg)
    current_user.update_seen(msg[:data])
    current_user.broadcast_update
    puts data
  end
end
