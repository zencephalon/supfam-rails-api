class AddMentionsToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :mentions, :jsonb
  end
end
