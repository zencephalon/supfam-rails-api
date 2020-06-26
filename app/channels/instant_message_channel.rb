# typed: false
class InstantMessageChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_for "#{params[:id]}"
  end

  def send_instant(data)
    self.broadcast_to("#{params[:id]}", { message: {
      conversation_id: params[:id],
      message: data['message'],
      type: 0,
      i: true,
      id: "i-#{data['profile_id']}",
      qid: data['qid'],
      profile_id: data['profile_id']
    }})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
