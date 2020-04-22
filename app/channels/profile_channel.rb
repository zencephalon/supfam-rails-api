class ProfileChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    profile = Profile.find(params[:id])
    stream_for profile
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
