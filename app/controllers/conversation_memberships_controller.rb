# typed: true
class ConversationMembershipsController < ApplicationController
  def me
    render json: @current_user.conversation_memberships.includes(conversation: :last_message).map(&:summary)
  end
end
