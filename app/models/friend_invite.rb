# typed: false
class FriendInvite < ApplicationRecord
  belongs_to :to_friend, foreign_key: :to_profile_id, class_name: 'Profile'
  belongs_to :from_friend, foreign_key: :from_profile_id, class_name: 'Profile'

  after_create_commit :send_notification

  validates :to_profile_id, uniqueness: { scope: :from_profile_id }

  enum status: { pending: 0, cancelled: 1, accepted: 2, declined: 3 }

  def summary
    {id: id, status: status, to_profile_id: to_profile_id, from_friend: from_friend.summary}
  end

  def send_notification
    FriendInviteNotificationWorker.perform_async(id)
  end
end
