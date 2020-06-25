class CreateFriendInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :friend_invites do |t|
      t.references :from_profile_id
      t.references :to_profile_id

      t.column :status, :integer, default: 0

      t.timestamps
    end
  end
end
