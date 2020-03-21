class StatusChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update_status(msg)
    current_user.update_status(msg['data'])
    current_user.broadcast_update
  end
end
