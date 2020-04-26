# typed: true
class RedoFriendships < ActiveRecord::Migration[6.0]
  def change
    drop_table :friendships
    create_table :friendships do |t|
      t.references :from_profile
      t.references :to_profile

      t.timestamps
    end
  end
end
