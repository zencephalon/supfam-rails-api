# typed: true
class RedoFriendInvites < ActiveRecord::Migration[6.0]
  def change
    drop_table :friend_invites
    create_table :friend_invites do |t|
      t.references :from_profile
      t.references :to_profile

      t.column :status, :integer, default: 0

      t.timestamps
    end
  end
end
