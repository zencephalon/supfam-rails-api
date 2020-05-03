# typed: false
class MessagesController < ApplicationController

  def send_message_to_profile
    conversation = Conversation.dmWith(@current_user.id, params[:to_profile_id])
    from_profile = @current_user.profiles.find(params[:from_profile_id])
    if conversation && from_profile
      render json: conversation.add_message(from_profile, msg_params)
    else
      render json: { error: "Invalid profile" }, status: :unprocessable_entity
    end
  end

  def messages_with_profile
    conversation = Conversation.dmWith(@current_user.id, params[:to_profile_id])
    messages = conversation.messages.eager_load(:profile).order(id: :desc)
    render json: messages
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def msg_params
      params.require(:message).permit(:type, :message)
    end
end
