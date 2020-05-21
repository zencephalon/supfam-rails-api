class AddFromAndToUserToFriendship < ActiveRecord::Migration[6.0]
  def change
    add_reference :friendships, :to_user, index: true
    add_reference :friendships, :from_user, index: true
  end
end
