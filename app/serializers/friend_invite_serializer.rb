# typed: strict
class FriendInviteSerializer < ActiveModel::Serializer
  attributes :from_friend, :to_friend, :status
end
