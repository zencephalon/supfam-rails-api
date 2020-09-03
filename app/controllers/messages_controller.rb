# typed: false
class MessagesController < ApplicationController
  before_action :set_message, only: %i[add_reaction remove_reaction flag]

  def send_message
    conversation = Conversation.find(params[:id])
    from_profile = @current_user.profiles.find(params[:from_profile_id])
    if conversation && from_profile
      render json: conversation.add_message(from_profile.id, msg_params)
    else
      render json: { error: 'Invalid profile' }, status: :unprocessable_entity
    end
  end

  def flag
    membership = ConversationMembership.where(conversation_id: @message.conversation_id, user_id: @current_user.id).first
    if membership
      @message.add_flag
      render json: {}
    else
      render_unauthorized
    end
  end

  def add_reaction
    membership = ConversationMembership.where(conversation_id: @message.conversation_id, profile_id: params[:profile_id]).first
    if membership
      @message.add_reaction(params[:profile_id], params[:emoji])
      render json: {}
    else
      render_unauthorized
    end
  end

  def remove_reaction
    membership = ConversationMembership.where(conversation_id: @message.conversation_id, profile_id: params[:profile_id]).first
    if membership
      @message.remove_reaction(params[:profile_id], params[:emoji])
      render json: {}
    else
      render_unauthorized
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Only allow a trusted parameter "allow list" through.
  def msg_params
    params.require(:message).permit(:type, :message, :qid, data: [:quoted, :quote_type, :profile_id, image: %i[width height uri]])
  end
end
