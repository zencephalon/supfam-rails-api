# typed: strict
class MessageSerializer < ActiveModel::Serializer
  attributes :id, :user_summary, :conversation_id, :type, :message
end
