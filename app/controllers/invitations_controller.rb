# typed: true
class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.create(
      from_profile_id: params[:from_profile_id],
      phone: params[:phone]
    )

    if @invitation.save
      render json: @invitation, status: :created
    else
      render json: @invitation.errors, status: :unprocessable_entity
    end
  end
end
