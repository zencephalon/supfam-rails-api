# typed: strong
class Friendship < ApplicationRecord
  validates :to_user_id, uniqueness: { scope: :from_user_id }
  validates :to_profile_id, uniqueness: { scope: :ffrom_profile_id }

  belongs_to :to_friend, foreign_key: :to_profile_id, class_name: 'Profile'
  belongs_to :from_friend, foreign_key: :from_profile_id, class_name: 'Profile'
end
