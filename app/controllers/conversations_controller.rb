# typed: false
class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:read, :preview]

  def read
    membership = @conversation.conversation_memberships.where(user_id: @current_user.id)[0]

    render json: { error: "Not a member of this conversation" }, status: 403 unless membership

    membership.last_read_message_id = @conversation.last_message_id
    
    if membership.save
      render json: {}
    else
      render json: { error: "Failed to save" }, status: 400
    end
  end

  def preview
    membership = @conversation.conversation_memberships.where(user_id: @current_user.id)[0]

    render json: { error: "Not a member of this conversation" }, status: 403 unless membership

    render json: @conversation.last_message
  end

  def membership
    membership = @conversation.conversation_memberships.where(user_id: @current_user.id)[0]

    render json: { error: "Not a member of this conversation" }, status: 403 unless membership

    render json: membership 
  end

  def conversation_with_profile
    conversation = Conversation.dmWith(@current_user.id, params[:to_profile_id])

    if conversation
      render json: conversation
    else
      render json: { error: "Conversation not found" }, status: 404
    end
  end

  def messages
    conversation = Conversation.find(params[:id])
    messages = conversation.get_messages_with_cursor(params[:cursor])
    render json: { messages: messages, next_cursor: messages.last&.id }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def conversation_params
      params.require(:conversation).permit(:dmId, :name)
    end
end
