class AddDataToMessage < ActiveRecord::Migration[6.0]
  def change
  	add_column :messages, :data, :jsonb
  end
end
