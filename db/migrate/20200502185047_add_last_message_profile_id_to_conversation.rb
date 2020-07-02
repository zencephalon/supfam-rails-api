# typed: false
class AddLastMessageProfileIdToConversation < ActiveRecord::Migration[6.0]
  def change
    remove_column :conversations, :last_message_user_id
    add_reference :conversations, :last_message_profile_id, index: true, references: "profiles"
  end
end
