# typed: false
class Profile < ApplicationRecord
  belongs_to :user
  has_many :friendships, foreign_key: 'from_profile_id'
  has_many :friends, through: :friendships, class_name: 'Profile', source: :to_friend

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

  def avatar_url
    signer = Aws::S3::Presigner.new
    signer.presigned_url(:get_object, bucket: "supfam-avatar", key: self.avatar_key)
  end

  def phone
    user.phone
  end

  def broadcast_update
    json = ActiveModelSerializers::Adapter::Json.new(
      ProfileSerializer.new(self)
    ).serializable_hash

    ProfileChannel.broadcast_to(self, json)
  end

  def broadcast_seen
    ProfileChannel.broadcast_to(self, { seen: self.seen })
  end

  def update_seen(params)
    new_seen = {}
    ["battery", "battery_state", "network_type", "network_strength"].each do |key|
      new_seen[key] = params[key]
    end
    new_seen["updated_at"] = DateTime.now()
    self.seen = (self.seen || {}).merge(new_seen)

    if self.save
      # self.broadcast_update
      self.broadcast_seen
    end
  end

  def update_status(params)
    new_status = {}
    if params[:message]
      new_status["message"] = params[:message]
    end
    if params[:color]
      new_status["color"] = params[:color]
    end
    self.status = (self.status || {}).merge(new_status)

    if self.save
      self.broadcast_update
      return true
    end
  end

  def summary
    return {id: self.id, name: self.name, avatar_url: self.avatar_url}
  end

  def micro_summary
    return {id: self.id}
  end

  before_create do
    if self.short_desc.nil?
      self.short_desc = ('a'..'z').to_a.sample
    end
    if self.status.nil?
      self.status = {
        message: 'I just joined, so everyone please welcome me! Sup fam?',
        color: 3,
      }
    end
  end

  after_create do |profile|
    # profile.status = {
    #   message: 'I just joined, so everyone please welcome me! Sup fam?',
    #   color: 3,
    # }
    # profile.save
  end
end
