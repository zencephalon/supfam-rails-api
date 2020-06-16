# typed: strict
class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :dmId, :name, :last_message, :last_message_profile_id, :message_count
end
