# typed: strong
require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "add_remove_reaction" do
  	m = Message.new

  	m.add_reaction(1, '!')

  	assert_equal [1], m.reactions['!']

  	m.add_reaction(1, '?')

  	assert_equal [1], m.reactions['?']

  	m.add_reaction(2, '?')

  	assert_equal [1,2], m.reactions['?']

  	m.remove_reaction(1, '?')

  	assert_equal [2], m.reactions['?']
  end
end
