# typed: true
class MessageChannel < ApplicationCable::Channel
  def subscribed
    unless current_user.conversation_memberships.where(conversation_id: params[:id]).first
      reject
    end

    stream_for "#{params[:id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
