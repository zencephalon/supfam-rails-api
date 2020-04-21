class Profile < ApplicationRecord
  belongs_to :user
  has_many :friendships, foreign_key: 'from_profile_id'
  has_many :friends, through: :friendships, class_name: 'Profile'

  def create_friendship(friend_profile_id)
    friend_profile = Profile.find_by(id: friend_profile_id)

    unless friend_profile
      return false
    end

    Profile.transaction do
      Friendship.create(from_profile_id: self.id, to_profile_id: friend_profile_id)
      Friendship.create(to_profile_id: self.id, from_profile_id: friend_profile_id)
    end

    return true
  end

  def update_status(params)
    new_status = {}
    if params[:message]
      new_status["message"] = params[:message]
    end
    if params[:color]
      new_status["color"] = params[:color]
    end
    self.status = self.status.merge(new_status)
    return self.save
  end

  after_create do |profile|
    profile.status = {
      message: 'I just joined, so everyone please welcome me! Sup fam?',
      color: 3,
    }
    profile.save
  end
end
