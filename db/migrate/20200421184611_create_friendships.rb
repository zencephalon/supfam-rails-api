# typed: true
class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.references :from_profile_id
      t.references :to_profile_id

      t.timestamps
    end
  end
end
