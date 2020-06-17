# typed: false
class ConversationMembership < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :conversation

  def summary
    {
      conversation_id: self.conversation_id,
      read: self.conversation.last_message_id == self.last_read_message_id,
      dmId: self.conversation.dmId
    }
  end
end
