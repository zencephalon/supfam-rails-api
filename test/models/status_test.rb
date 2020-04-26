# typed: false
require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Status fixture" do
    assert_equal "Hello, I feel cooped up now", statuses(:one).message
    # assert_equal "Hello, I feel cooped up now", statuses(:two).message
    assert_equal users(:matt), statuses(:one).user
    assert_equal users(:daria), statuses(:two).user
    # assert_equal users(:matt).name, statuses(:one).user.name
  end
end
