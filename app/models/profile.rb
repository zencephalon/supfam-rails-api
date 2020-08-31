# typed: false
class Profile < ApplicationRecord
  belongs_to :user
  has_many :friendships, foreign_key: 'from_profile_id'
  has_many :friends, through: :friendships, class_name: 'Profile', source: :to_friend

  def create_friend_invite(friend_profile_id)
    friend_profile = Profile.find_by(id: friend_profile_id)

    return false unless friend_profile

    return FriendInvite.create(from_profile_id: self.id, to_profile_id: friend_profile_id)
  end

  def cancel_friend_invite(to_profile_id)
    pending_invites = FriendInvite.where(from_profile_id: self.id, to_profile_id: to_profile_id, status: :pending);

    return false unless pending_invites

    pending_invites.each do |invite|
      invite.status = :cancelled
      invite.save
    end

    return true
  end

  def decline_friend_invite(from_profile_id)
    pending_invites = FriendInvite.where(from_profile_id: from_profile_id, to_profile_id: self.id, status: :pending);

    return false unless pending_invites

    pending_invites.each do |invite|
      invite.status = :declined
      invite.save
    end

    return true
  end

  def accept_friend_invite(from_profile_id)
    pending_invites = FriendInvite.where(from_profile_id: from_profile_id, to_profile_id: self.id, status: :pending);

    return false unless pending_invites

    pending_invites.each do |invite|
      invite.status = :accepted
      invite.save
    end

    # Create friendship
    self.create_friendship(from_profile_id)

    return true
  end

  def friend_invites_from()
    invites = FriendInvite.where(from_profile_id: self.id);

    return false unless invites

    return invites
  end

  def friend_invites_to()
    invites = FriendInvite.where(to_profile_id: self.id);

    return false unless invites

    return invites
  end

  def create_friendship(friend_profile_id)
    friend_profile = Profile.find_by(id: friend_profile_id)

    return false unless friend_profile

    Profile.transaction do
      Friendship.create!(from_profile_id: self.id, to_profile_id: friend_profile_id, from_user_id: self.user_id, to_user_id: friend_profile.user_id)
      Friendship.create!(to_profile_id: self.id, from_profile_id: friend_profile_id, to_user_id: self.user_id, from_user_id: friend_profile.user_id)
    end

    # Setup the conversation immediately
    Conversation.dmWith(self.user_id, friend_profile_id)
    NewFriendNotificationWorker.perform_async(friend_profile_id, self.id)

    return true
  end

  def delete_friendship(friend_profile_id)
    friend_profile = Profile.find_by(id: friend_profile_id)

    return false unless friend_profile

    Profile.transaction do
      friendship_to = Friendship.where(from_profile_id: self.id, to_profile_id: friend_profile_id).destroy_all
      friendship_from = Friendship.where(from_profile_id: self.id, to_profile_id: friend_profile_id).destroy_all
    end

    return true
  end

  def avatar_url
    # signer = Aws::S3::Presigner.new
    # signer.presigned_url(:get_object, bucket: "supfam-avatar", key: self.avatar_key)
    avatar_key ? "https://supfam-avatar.s3.us-east-2.amazonaws.com/#{avatar_key}" : "https://ui-avatars.com/api/?background=B48EAD&color=fff&name=#{self.name.split(' ').join('+')}"
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
    self.save
  end

  def update_location(params, updated_at = nil)
    new_location = params.slice("latitude", "longitude")
    new_location["updated_at"] = updated_at || DateTime.now()
    self.location = (self.location || {}).merge(new_location)
    self.save
  end

  def update_status(params, updated_at = nil)
    new_status = {}
    old_status = self.status

    new_status["updated_at"] = updated_at || DateTime.now()
    new_status["message"] = params[:message] if params[:message]
    new_status["color"] = params[:color] if params[:color]

    self.status = (old_status || {}).merge(new_status)
    self.broadcast_status
    old_updated_at = old_status["updated_at"]
    StatusUpgradePushNoWorker.perform_in(1.seconds, self.id) if self.status["color"] > old_status["color"] and (!old_updated_at or (DateTime.parse(old_updated_at) + 5.minute) < self.status["updated_at"])

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

  after_create_commit do |profile|
    invitations = Invitation.where(phone: profile.user.phone);
    invitations.each do |invitation|
      if invitation.status == "pending"
        profile.create_friendship(invitation.from_profile_id)
        invitation.status = :accepted
        invitation.save
      end
    end
  end
end
