# typed: false
class AddLastStatusIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :current_status_id, :bigint

    User.all.each do |user|
      user.current_status_id = user.current_status.id
      user.save
    end
  end
end
