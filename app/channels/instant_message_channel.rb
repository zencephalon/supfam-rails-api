# typed: true
class InstantMessageChannel < ApplicationCable::Channel
  def subscribed
    reject unless current_user.conversation_memberships.where(conversation_id: params[:id]).first

    stream_for params[:id].to_s
  end

  def send_instant(data)
    broadcast_to(params[:id].to_s, { message: {
                   conversation_id: params[:id],
                   message: data['message'],
                   type: 0,
                   i: true,
                   id: "i-#{data['profile_id']}",
                   qid: data['qid'],
                   profile_id: data['profile_id']
                 } })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
