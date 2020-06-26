# typed: strong
class FriendInvite < ApplicationRecord
  belongs_to :to_friend, foreign_key: :to_profile_id, class_name: 'Profile'
  belongs_to :from_friend, foreign_key: :from_profile_id, class_name: 'Profile'

  enum status: { pending: 0, cancelled: 1, accepted: 2, declined: 3 }

  def summary
    return {id: self.id, status: self.status, to_profile_id: self.to_profile_id, from_friend: self.from_friend.summary}
  end
end
