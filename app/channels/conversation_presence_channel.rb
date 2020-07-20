# typed: true
class ConversationPresenceChannel < ApplicationCable::Channel
  def subscribed
    unless current_user.conversation_memberships.where(conversation_id: params[:id]).first
      reject
    end

    stream_for "#{params[:id]}"
    self.broadcast_to("#{params[:id]}", { event: "heartbeat", profile_id: params[:profile_id], conversation_id: params[:id] })
  end

  def unsubscribed
    self.broadcast_to("#{params[:id]}", { event: "disconnect", profile_id: params[:profile_id], conversation_id: params[:id] })
  end

  def heartbeat()
    self.broadcast_to("#{params[:id]}", { event: "heartbeat", profile_id: params[:profile_id], conversation_id: params[:id] })
  end
end
