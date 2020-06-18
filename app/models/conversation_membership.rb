# typed: false
class ConversationMembership < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :conversation

  def summary
    {
      conversation_id: self.conversation_id,
      last_message: self.conversation.last_message,
      last_read_message_id: self.last_read_message_id,
      dmId: self.conversation.dmId,
      user_id: self.user_id
    }
  end

  def broadcast_read(conversation)
    ConversationChannel.broadcast_to(conversation, self.summary)
  end
end
