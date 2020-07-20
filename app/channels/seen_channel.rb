# typed: false
class SeenChannel < ApplicationCable::Channel
  def subscribed
    stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update_seen(msg)
    ProfileChannel.broadcast_to("#{msg['profile_id']}", { seen: msg['data'], profile_id: msg['profile_id'] })
    SeenUpdateWorker.perform_async(current_user.id, msg['profile_id'], msg['data'])
  end
end
