class AddUniqueIndexToInvites < ActiveRecord::Migration[6.0]
  def change
    add_index :friend_invites, %i[to_profile_id from_profile_id], unique: true
  end
end
