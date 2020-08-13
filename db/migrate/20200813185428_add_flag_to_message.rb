class AddFlagToMessage < ActiveRecord::Migration[6.0]
  def change
  	add_column :messages, :flag, :boolean
  end
end
