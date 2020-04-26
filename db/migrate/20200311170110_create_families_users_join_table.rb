# typed: true
class CreateFamiliesUsersJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :families, :users do |t|
      t.index :family_id
      t.index :user_id
    end
  end
end
