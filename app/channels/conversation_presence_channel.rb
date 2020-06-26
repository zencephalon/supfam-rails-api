class ConversationPresenceChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_for "#{params[:id]}"
    self.broadcast_to("#{params[:id]}", { event: "heartbeat", profile_id: params[:profile_id], conversation_id: params[:id] })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # don't have profile information here to know who disconnected :/
    self.broadcast_to("#{params[:id]}", { event: "disconnect", profile_id: params[:profile_id], conversation_id: params[:id] })
  end

  def heartbeat()
    self.broadcast_to("#{params[:id]}", { event: "heartbeat", profile_id: params[:profile_id], conversation_id: params[:id] })
  end
end
