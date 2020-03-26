class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :update, :destroy]

  def my_dms
    render json: @current_user.dms_by_friend_id
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
