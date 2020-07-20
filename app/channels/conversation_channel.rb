# typed: true
class ConversationChannel < ApplicationCable::Channel
  def subscribed
  	current_user.conversation_memberships.pluck(:conversation_id).each do |conversation_id|
	    stream_for "#{conversation_id}"
	  end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
