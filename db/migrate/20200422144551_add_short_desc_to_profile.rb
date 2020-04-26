# typed: true
class AddShortDescToProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :short_desc, :string
  end
end
