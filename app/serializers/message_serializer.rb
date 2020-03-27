class MessageSerializer < ActiveModel::Serializer
  attributes :id, :user, :conversation_id, :type, :message
end
