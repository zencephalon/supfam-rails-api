# typed: false
class ConversationMembership < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :profile
  belongs_to :conversation

  enum type: %i[member admin]

  def summary
    {
      conversation_id: conversation_id,
      last_message: conversation.last_message,
      last_read_message_id: last_read_message_id,
      last_message_profile_id: conversation.last_message_profile_id,
      dmId: conversation.dmId,
      user_id: user_id
    }
  end

  # TODO: enable this when we want to support read-avatar heads like Facebook has
  # def broadcast_read(conversation)
  #   ConversationChannel.broadcast_to("#{conversation.id}", self.summary)
  # end
end
