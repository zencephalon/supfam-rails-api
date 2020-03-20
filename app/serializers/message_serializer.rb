class MessageSerializer < ActiveModel::Serializer
  attributes :id, :user, :conversation, :type, :message
end
