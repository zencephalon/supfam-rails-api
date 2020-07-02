# typed: false
class AddLastMessageProfileIdToConversation2 < ActiveRecord::Migration[6.0]
  def change
    remove_column :conversations, :last_message_profile_id_id
    add_reference :conversations, :last_message_profile, index: true, references: "profiles"
  end
end
