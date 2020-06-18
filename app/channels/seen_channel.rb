# typed: false
class SeenChannel < ApplicationCable::Channel
  def subscribed
    stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update_seen(msg)
    current_profile = current_user.profiles.find_by(id: msg['profile_id'])
    current_profile.update_seen(msg['data']) if current_profile
  end
end
