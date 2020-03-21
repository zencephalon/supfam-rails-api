require 'test_helper'

class ConversationMembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conversation_membership = conversation_memberships(:one)
  end

  # test "should get index" do
  #   get conversation_memberships_url, as: :json
  #   assert_response :success
  # end

  # test "should create conversation_membership" do
  #   assert_difference('ConversationMembership.count') do
  #     post conversation_memberships_url, params: { conversation_membership: { conversation: @conversation_membership.conversation, last_read_message_num: @conversation_membership.last_read_message_num, type: @conversation_membership.type, user: @conversation_membership.user } }, as: :json
  #   end

  #   assert_response 201
  # end

  # test "should show conversation_membership" do
  #   get conversation_membership_url(@conversation_membership), as: :json
  #   assert_response :success
  # end

  # test "should update conversation_membership" do
  #   patch conversation_membership_url(@conversation_membership), params: { conversation_membership: { conversation: @conversation_membership.conversation, last_read_message_num: @conversation_membership.last_read_message_num, type: @conversation_membership.type, user: @conversation_membership.user } }, as: :json
  #   assert_response 200
  # end

  # test "should destroy conversation_membership" do
  #   assert_difference('ConversationMembership.count', -1) do
  #     delete conversation_membership_url(@conversation_membership), as: :json
  #   end

  #   assert_response 204
  # end
end
