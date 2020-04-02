require 'json'

class InstantMessageChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_for "instant:#{params[:id]}"
  end

  def send_instant(data)
    self.broadcast_to("instant:#{params[:id]}", {
      message: data['message'],
      type: 0,
      id: 'instant',
      user_summary: current_user.summary
  }.to_json)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
