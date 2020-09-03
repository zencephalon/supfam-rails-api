# typed: true
class ConversationPresenceChannel < ApplicationCable::Channel
  def subscribed
    reject unless current_user.conversation_memberships.where(conversation_id: params[:id]).first

    stream_for params[:id].to_s
    broadcast_to(params[:id].to_s, { event: 'heartbeat', profile_id: params[:profile_id], conversation_id: params[:id] })
  end

  def unsubscribed
    broadcast_to(params[:id].to_s, { event: 'disconnect', profile_id: params[:profile_id], conversation_id: params[:id] })
  end

  def heartbeat
    broadcast_to(params[:id].to_s, { event: 'heartbeat', profile_id: params[:profile_id], conversation_id: params[:id] })
  end
end
