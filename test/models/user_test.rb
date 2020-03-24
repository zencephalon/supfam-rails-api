require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User fixture" do
    assert_equal users(:matt).name, 'Matt'
    assert_equal users(:matt).families.size, 2
  end

  test "User.friends" do
    assert_equal 4, users(:matt).friends.size
    assert_equal 2, users(:daria).friends.size
    assert_equal 2, users(:condon).friends.size
  end

  # test "User.dms" do
  #   assert_equal 4, users(:matt).dms.size
  # end

  test "User.direct_messages" do
    # assert_equal "1:2", users(:matt).direct_conversations.first.dmId
    assert_equal 3, users(:matt).direct_conversations.size
  end

  test "User.get_friend_id_from_dm_id" do
    assert_equal 5, users(:matt).get_friend_id_from_dm_id("1:5")
  end

  test "User.dms_by_friend_id" do
    assert_equal conversations(:dm_12), users(:matt).dms_by_friend_id[2]
  end

end
