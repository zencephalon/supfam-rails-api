class SeenChannel < ApplicationCable::Channel
  def subscribed
    stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # TODO: we probably don't need a seperate channel for this, can just merge with family channel
  def update_seen(msg)
    # TODO: we shouldn't need this if we just broadcast the seen update itself instead of the entire user
    current_profile.reload
    current_profile.update_seen(msg['data'])
  end
end
