# typed: strict
class MessageSerializer < ActiveModel::Serializer
  attributes :id, :profile, :conversation_id, :type, :message
end
