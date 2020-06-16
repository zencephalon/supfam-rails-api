# typed: false
class ConversationMembershipsController < ApplicationController

  def me
    # TODO: just for demo, we'll have to change this later
    render json: @current_user.conversation_memberships.includes(:conversation)
  end
end
