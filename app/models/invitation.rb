# typed: strict
class Invitation < ApplicationRecord
  belongs_to :from_friend, foreign_key: :from_profile_id, class_name: 'Profile'

  enum status: { pending: 0, cancelled: 1, accepted: 2 }
end
