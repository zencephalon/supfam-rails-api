# typed: false
class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[read preview membership add_members remove_member update_name messages sync_messages show]
  before_action :check_membership, only: %i[read preview membership add_members remove_member update_name messages sync_messages show]

  def show
    render json: @conversation.summary
  end

  def create_with_members
    c = Conversation.create
    c.add_conversation_members_by_profile_ids([params[:creatorId]], :admin) if params[:creatorId]
    c.add_conversation_members_by_profile_ids(params[:profileIds])

    render json: { conversation_id: c.id }
  end

  def update_name
    @conversation.name = params[:name]
    @conversation.save

    render json: {}
  end

  def add_members
    @conversation.add_conversation_members_by_profile_ids(params[:profileIds])
  end

  def remove_member
    @conversation.remove_member_by_profile_id(params[:profileId])
  end

  def read
    # TODO: enable this when we want to support read-avatar heads like Facebook has
    # membership.broadcast_read(@conversation)
    @membership.last_read_message_id = params[:msgId]

    if @membership.save
      render json: {}
    else
      render json: { error: 'Failed to save' }, status: 400
    end
  end

  def preview
    render json: @conversation.last_message
  end

  def membership
    render json: @membership.summary
  end

  def conversation_with_profile
    conversation = Conversation.dmWith(@current_user.id, params[:to_profile_id].to_i)

    if conversation
      render json: conversation
    else
      render json: { error: 'Conversation not found' }, status: 404
    end
  end

  def groups
    render json: @current_user.group_conversations
  end

  def messages
    messages = @conversation.get_messages_with_cursor(params[:cursor])
    render json: { messages: messages, next_cursor: messages.last&.id }
  end

  def sync_messages
    messages = @conversation.get_messages_with_precursor(params[:precursor])
    render json: { messages: messages }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def check_membership
    @membership = @conversation.conversation_memberships.where(user_id: @current_user.id).first

    unless @membership
      render json: { error: 'Not a member of this conversation' }, status: 403
      nil
    end
  end

  # Only allow a trusted parameter "white list" through.
  def conversation_params
    params.require(:conversation).permit(:dmId, :name)
  end
end
