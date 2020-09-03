# typed: true
class ConversationChannel < ApplicationCable::Channel
  def subscribed
    current_user.conversation_memberships.pluck(:conversation_id).each do |conversation_id|
      stream_for conversation_id.to_s
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
