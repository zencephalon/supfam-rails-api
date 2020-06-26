# typed: false
class FriendInvitesController < ApplicationController
  def create
    profile = @current_user.profiles.find_by(id: params[:from_profile_id])
    @friendInvite = profile.create_friend_invite(params[:to_profile_id])

    if @friendInvite.save
      render json: @friendInvite, status: :created
    else
      render json: @friendInvite.errors, status: :unprocessable_entity
    end
  end

  def cancel
    profile = @current_user.profiles.find_by(id: params[:from_profile_id])
    profile.cancel_friend_invite(params[:to_profile_id])

    render json: {}
  end

  def from
    profile = @current_user.profiles.find_by(id: params[:from_profile_id])

    unless profile
      render json: []
      return
    end

    result = profile.friend_invites_from()
    render json: result
  end

  def to
    profile = @current_user.profiles.find_by(id: params[:to_profile_id])

    unless profile
      render json: []
      return
    end

    result = profile.friend_invites_to()
    render json: result
  end
end
