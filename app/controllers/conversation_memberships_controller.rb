# typed: false
class ConversationMembershipsController < ApplicationController
  before_action :set_conversation_membership, only: [:show, :update, :destroy]

  # GET /conversation_memberships
  def index
    @conversation_memberships = ConversationMembership.all

    render json: @conversation_memberships
  end

  # GET /conversation_memberships/1
  def show
    render json: @conversation_membership
  end

  # POST /conversation_memberships
  def create
    @conversation_membership = ConversationMembership.new(conversation_membership_params)

    if @conversation_membership.save
      render json: @conversation_membership, status: :created, location: @conversation_membership
    else
      render json: @conversation_membership.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /conversation_memberships/1
  def update
    if @conversation_membership.update(conversation_membership_params)
      render json: @conversation_membership
    else
      render json: @conversation_membership.errors, status: :unprocessable_entity
    end
  end

  # DELETE /conversation_memberships/1
  def destroy
    @conversation_membership.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation_membership
      @conversation_membership = ConversationMembership.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def conversation_membership_params
      params.require(:conversation_membership).permit(:user, :conversation, :type, :last_read_message_num)
    end
end
