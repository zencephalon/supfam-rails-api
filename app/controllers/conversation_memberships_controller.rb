# typed: false
class ConversationMembershipsController < ApplicationController

  def me
    render json: @current_user.conversation_memberships.includes(:conversation).map(&:summary)
  end
end
