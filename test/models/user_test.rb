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

  test "User.dms" do
    assert_equal 4, users(:matt).dms.size
  end
end
