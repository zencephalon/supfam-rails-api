# typed: false
class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :update, :destroy]



  def conversation_with_profile
    conversation = Conversation.dmWith(@current_user.id, params[:to_profile_id])

    if conversation
      render json: conversation
    else
      render json: { error: "Conversation not found" }
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
