# typed: strict
class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :dmId, :name, :last_message_id, :last_message_user_id, :message_count
end
