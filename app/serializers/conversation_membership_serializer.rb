# typed: strict
class ConversationMembershipSerializer < ActiveModel::Serializer
  attributes :id, :user, :conversation, :type, :last_read_message_num
end
