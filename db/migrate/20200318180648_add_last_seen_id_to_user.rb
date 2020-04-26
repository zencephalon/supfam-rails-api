# typed: true
class AddLastSeenIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :current_seen_id, :bigint
  end
end
