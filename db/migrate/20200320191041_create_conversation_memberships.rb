class CreateConversationMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :conversation_memberships do |t|
      t.references :user
      t.references :conversation
      t.integer :type
      t.integer :last_read_message_num

      t.timestamps
    end
  end
end
