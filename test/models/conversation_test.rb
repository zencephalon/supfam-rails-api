require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Conversation.getDmId" do
    assert_equal "1:4", Conversation.getDmId([1, 4])
    assert_equal "1:4", Conversation.getDmId([4, 1])
  end
end
