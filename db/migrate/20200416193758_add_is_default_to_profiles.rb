class AddIsDefaultToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :is_default, :boolean
  end
end
