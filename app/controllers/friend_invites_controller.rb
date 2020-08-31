# typed: true
class FriendInvitesController < ApplicationController
  def create
    profile = @current_user.profiles.find_by(id: params[:from_profile_id])
    friend_invite = profile.create_friend_invite(params[:to_profile_id])

    if friend_invite.save
      render json: friend_invite, status: :created
    else
      render json: friend_invite.errors, status: :unprocessable_entity
    end
  end

  def cancel
    profile = @current_user.profiles.find_by(id: params[:from_profile_id])
    profile.cancel_friend_invite(params[:to_profile_id])

    render json: {}
  end

  def decline
    profile = @current_user.profiles.find_by(id: params[:to_profile_id])
    profile.decline_friend_invite(params[:from_profile_id])

    render json: {}
  end

  def accept
    profile = @current_user.profiles.find_by(id: params[:to_profile_id])
    profile.accept_friend_invite(params[:from_profile_id])

    render json: {}
  end

  def from
    profile = @current_user.profiles.find_by(id: params[:from_profile_id])

    unless profile
      render json: []
      return
    end

    result = profile.friend_invites_from()
    render json: result.map(&:summary);
  end

  def to
    profile = @current_user.profiles.find_by(id: params[:to_profile_id])

    unless profile
      render json: []
      return
    end

    result = profile.friend_invites_to()
    render json: result.map(&:summary);
  end

  def block
    profile = @current_user.profiles.find_by(id: params[:from_profile_id])
    profile.delete_friendship(params[:to_profile_id])

    render json: {}
  end

  def phone_lookup
    to_user = User.find_by(phone: params[:phone])

    unless to_user
      render json: {result: 'no_user'}
      return
    end

    to_profile = to_user.profiles.first
    from_profile = @current_user.profiles.find_by(id: params[:from_profile_id])

    unless from_profile && to_profile
      render json: {result: 'no_user'}
      return
    end

    existing_friendship = Friendship.where(from_profile_id: from_profile.id, to_profile_id: to_profile.id).first

    if existing_friendship
      render json: {result: 'existing_friendship'}
      return
    end

    existing_invite = FriendInvite.where(from_profile_id: from_profile.id, to_profile_id: to_profile.id).first

    if existing_invite
      render json: {result: 'existing_invite'}
      return
    end

    render json: { result: 'user_found', profile_id: to_profile.id }
  end
end
