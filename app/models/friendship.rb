# typed: strong
class Friendship < ApplicationRecord
  belongs_to :to_friend, foreign_key: :to_profile_id, class_name: 'Profile'
end
