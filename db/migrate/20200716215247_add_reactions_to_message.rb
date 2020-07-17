class AddReactionsToMessage < ActiveRecord::Migration[6.0]
  def change
  	add_column :messages, :reactions, :jsonb
  end
end
