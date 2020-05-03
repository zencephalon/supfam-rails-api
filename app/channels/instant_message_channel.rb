# typed: false
class InstantMessageChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_for "instant:#{params[:id]}"
  end

  def send_instant(data)
    self.broadcast_to("instant:#{params[:id]}", { message: {
      message: data['message'],
      type: 0,
      id: 'i',
      profile_summary: current_profile.micro_summary
    }})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
