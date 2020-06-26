# typed: false
class FriendInvitesController < ApplicationController
  def create
    profile = @current_user.profiles.find_by(id: params[:from_profile_id])
    @friendInvite = profile.create_friend_invite(params[:to_profile_id]);

    if @friendInvite.save
      render json: @friendInvite, status: :created
    else
      render json: @friendInvite.errors, status: :unprocessable_entity
    end
  end

  def cancel
    profile = @current_user.profiles.find_by(id: params[:from_profile_id])
    profile.cancel_friend_invite(params[:to_profile_id]);

    render json: {}
  end
end
