class ChangeToLastReadMessageId < ActiveRecord::Migration[6.0]
  def change
    remove_column :conversation_memberships, :last_read_message_num
    add_reference :conversation_memberships, :last_read_message, references: "messages"
  end
end
