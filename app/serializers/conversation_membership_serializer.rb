# typed: strict
class ConversationMembershipSerializer < ActiveModel::Serializer
  attributes :id, :conversation, :type, :last_read_message_id
end
