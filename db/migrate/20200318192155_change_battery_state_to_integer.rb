class ChangeBatteryStateToInteger < ActiveRecord::Migration[6.0]
  def change
    remove_column :seens, :battery_state
    add_column :seens, :battery_state, :integer
  end
end
