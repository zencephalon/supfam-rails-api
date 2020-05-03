# typed: strict
class MessageSerializer < ActiveModel::Serializer
  attributes :id, :profile_summary, :conversation_id, :type, :message
end
