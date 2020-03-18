class CreateSeens < ActiveRecord::Migration[6.0]
  def change
    create_table :seens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :network_type
      t.integer :network_strength
      t.string :cellular_generation
      t.float :battery
      t.string :battery_state
      t.float :lat
      t.float :long
      t.string :client_type

      t.timestamps
    end
  end
end
