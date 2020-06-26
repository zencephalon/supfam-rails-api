# typed: false
class Profile < ApplicationRecord
  belongs_to :user
  has_many :friendships, foreign_key: 'from_profile_id'
  has_many :friends, through: :friendships, class_name: 'Profile', source: :to_friend

  def create_friend_invite(friend_profile_id)
    friend_profile = Profile.find_by(id: friend_profile_id)

    unless friend_profile
      return false
    end

    Profile.transaction do
      FriendInvite.create(from_profile_id: self.id, to_profile_id: friend_profile_id)
    end

    return true
  end

  def create_friendship(friend_profile_id)
    friend_profile = Profile.find_by(id: friend_profile_id)

    unless friend_profile
      return false
    end

    Profile.transaction do
      Friendship.create(from_profile_id: self.id, to_profile_id: friend_profile_id, from_user_id: self.id, to_user_id: friend_profile.user_id)
      Friendship.create(to_profile_id: self.id, from_profile_id: friend_profile_id, to_user_id: self.id, from_user_id: friend_profile.user_id)
    end

    # Setup the conversation immediately
    Conversation.dmWith(self.user_id, friend_profile_id)

    return true
  end

  def avatar_url
    # signer = Aws::S3::Presigner.new
    # signer.presigned_url(:get_object, bucket: "supfam-avatar", key: self.avatar_key)
    "https://supfam-avatar.s3.us-east-2.amazonaws.com/#{avatar_key}"
  end

  def phone
    user.phone
  end

  # TODO: should probably just handle this the same way we handle Seen
  def broadcast_status
    json = ActiveModelSerializers::Adapter::Json.new(
      ProfileSerializer.new(self)
    ).serializable_hash

    ProfileChannel.broadcast_to("#{self.id}", { status: self.status, profile_id: self.id })
  end

  def broadcast_seen
    ProfileChannel.broadcast_to("#{self.id}", { seen: self.seen, profile_id: self.id })
  end

  def update_seen(params, updated_at = nil)
    new_seen = params.slice("battery", "battery_state", "network_type", "network_strength")
    new_seen["updated_at"] = updated_at || DateTime.now()
    self.seen = (self.seen || {}).merge(new_seen)

    self.broadcast_seen

    self.save
  end

  def update_status(params)
    new_status = {}
    old_status = self.status

    new_status["updated_at"] = DateTime.now()
    new_status["message"] = params[:message] if params[:message]
    new_status["color"] = params[:color] if params[:color]

    self.status = (old_status || {}).merge(new_status)
    self.broadcast_status
    old_updated_at = old_status["updated_at"]
    StatusUpgradePushNoWorker.perform_async(self.id) if new_status["color"] > old_status["color"] and (!old_updated_at or (DateTime.parse(old_updated_at) + 5.minute) < new_status["updated_at"])

    return self.save
  end



  def summary
    return {id: self.id, name: self.name, avatar_url: self.avatar_url, user_id: self.user_id}
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
