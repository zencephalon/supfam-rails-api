class AddLinksToMessages < ActiveRecord::Migration[6.0]
  def change
  	add_column :messages, :links, :jsonb
  end
end
