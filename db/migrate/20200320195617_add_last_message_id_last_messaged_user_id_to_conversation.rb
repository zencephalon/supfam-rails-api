class AddLastMessageIdLastMessagedUserIdToConversation < ActiveRecord::Migration[6.0]
  def change
    add_column :conversations, :last_message_id, :bigint
    add_column :conversations, :last_message_user_id, :bigint
    add_column :conversations, :message_count, :integer
  end
end
