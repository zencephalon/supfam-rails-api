class AddProfileIdToMessage < ActiveRecord::Migration[6.0]
  def change
    remove_column :messages, :user_id
    add_reference :messages, :profile, index: true
  end
end
