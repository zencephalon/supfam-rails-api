# typed: strict
class MessageSerializer < ActiveModel::Serializer
  attributes :id, :profile_id, :conversation_id, :type, :message, :qid, :links, :data, :mentions
end
