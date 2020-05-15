class AddQidToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :qid, :float
  end
end
