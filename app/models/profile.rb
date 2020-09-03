# typed: false
class Profile < ApplicationRecord
  belongs_to :user
  has_many :friendships, foreign_key: 'from_profile_id'
  has_many :friends, through: :friendships, class_name: 'Profile', source: :to_friend

  def create_friend_invite(friend_profile_id)
    friend_profile = Profile.find_by(id: friend_profile_id)

    return false unless friend_profile

    FriendInvite.create(from_profile_id: id, to_profile_id: friend_profile_id)
  end

  def cancel_friend_invite(to_profile_id)
    pending_invites = FriendInvite.where(from_profile_id: id, to_profile_id: to_profile_id, status: :pending)

    return false unless pending_invites

    pending_invites.each do |invite|
      invite.status = :cancelled
      invite.save
    end

    true
  end

  def decline_friend_invite(from_profile_id)
    pending_invites = FriendInvite.where(from_profile_id: from_profile_id, to_profile_id: id, status: :pending)

    return false unless pending_invites

    pending_invites.each do |invite|
      invite.status = :declined
      invite.save
    end

    true
  end

  def accept_friend_invite(from_profile_id)
    pending_invites = FriendInvite.where(from_profile_id: from_profile_id, to_profile_id: id, status: :pending)

    return false unless pending_invites

    pending_invites.each do |invite|
      invite.status = :accepted
      invite.save
    end

    # Create friendship
    create_friendship(from_profile_id)

    true
  end

  def friend_invites_from
    invites = FriendInvite.where(from_profile_id: id)

    return false unless invites

    invites
  end

  def friend_invites_to
    invites = FriendInvite.where(to_profile_id: id)

    return false unless invites

    invites
  end

  def create_friendship(friend_profile_id)
    friend_profile = Profile.find_by(id: friend_profile_id)

    return false unless friend_profile

    Profile.transaction do
      Friendship.create!(from_profile_id: id, to_profile_id: friend_profile_id, from_user_id: user_id, to_user_id: friend_profile.user_id)
      Friendship.create!(to_profile_id: id, from_profile_id: friend_profile_id, to_user_id: user_id, from_user_id: friend_profile.user_id)
    end

    # Setup the conversation immediately
    Conversation.dmWith(user_id, friend_profile_id)
    NewFriendNotificationWorker.perform_async(friend_profile_id, id)

    true
  end

  def delete_friendship(friend_profile_id)
    friend_profile = Profile.find_by(id: friend_profile_id)

    return false unless friend_profile

    Profile.transaction do
      friendship_to = Friendship.where(from_profile_id: id, to_profile_id: friend_profile_id).destroy_all
      friendship_from = Friendship.where(to_profile_id: id, from_profile_id: friend_profile_id).destroy_all
    end

    true
  end

  def avatar_url
    # signer = Aws::S3::Presigner.new
    # signer.presigned_url(:get_object, bucket: "supfam-avatar", key: self.avatar_key)
    avatar_key ? "https://supfam-avatar.s3.us-east-2.amazonaws.com/#{avatar_key}" : "https://ui-avatars.com/api/?background=B48EAD&color=fff&name=#{name.split(' ').join('+')}"
  end

  def phone
    user.phone
  end

  # TODO: should probably just handle this the same way we handle Seen
  def broadcast_status
    json = ActiveModelSerializers::Adapter::Json.new(
      ProfileSerializer.new(self)
    ).serializable_hash

    ProfileChannel.broadcast_to(id.to_s, { status: status, profile_id: id })
  end

  def broadcast_seen
    ProfileChannel.broadcast_to(id.to_s, { seen: seen, profile_id: id })
  end

  def update_seen(params, updated_at = nil)
    new_seen = params.slice('battery', 'battery_state', 'network_type', 'network_strength')
    new_seen['updated_at'] = updated_at || DateTime.now
    self.seen = (seen || {}).merge(new_seen)
    save
  end

  def update_location(params, updated_at = nil)
    new_location = params.slice('latitude', 'longitude')
    new_location['updated_at'] = updated_at || DateTime.now
    self.location = (location || {}).merge(new_location)
    save
  end

  def update_status(params, updated_at = nil)
    new_status = {}
    old_status = status

    new_status['updated_at'] = updated_at || DateTime.now
    new_status['message'] = params[:message] if params[:message]
    new_status['color'] = params[:color] if params[:color]

    self.status = (old_status || {}).merge(new_status)
    broadcast_status
    old_updated_at = old_status['updated_at']
    if (status['color'] > old_status['color']) && (!old_updated_at || ((DateTime.parse(old_updated_at) + 5.minute) < status['updated_at']))
      StatusUpgradePushNoWorker.perform_in(1.seconds, id)
    end

    save
  end

  def summary
    {id: id, name: name, avatar_url: avatar_url, user_id: user_id}
  end

  before_create do
    self.short_desc = ('a'..'z').to_a.sample if short_desc.nil?
    if status.nil?
      self.status = {
        message: 'I just joined, so everyone please welcome me! Sup fam?',
        color: 3
      }
    end
  end

  after_create_commit do |profile|
    invitations = Invitation.where(phone: profile.user.phone)
    invitations.each do |invitation|
      next unless invitation.status == 'pending'

      profile.create_friendship(invitation.from_profile_id)
      invitation.status = :accepted
      invitation.save
    end
  end
end
