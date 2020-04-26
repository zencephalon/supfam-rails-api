# typed: false
class MessagesController < ApplicationController

  def send_message_to_user
    conversation = Conversation.dmWith(@current_user.id, params[:to_user_id])
    render json: conversation.add_message(@current_user.id, msg_params)
  end

  def messages_with_user
    conversation = Conversation.dmWith(@current_user.id, params[:to_user_id])
    messages = conversation.messages.eager_load(:user).order(id: :desc)
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
