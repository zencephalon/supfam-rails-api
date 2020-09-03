class AddUniqueIndexToFriendships < ActiveRecord::Migration[6.0]
  def change
    add_index :friendships, %i[to_user_id from_user_id], unique: true
  end
end
