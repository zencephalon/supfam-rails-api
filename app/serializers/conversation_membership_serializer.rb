class ConversationMembershipSerializer < ActiveModel::Serializer
  attributes :id, :user, :conversation, :type, :last_read_message_index
end
