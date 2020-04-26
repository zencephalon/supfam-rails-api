# typed: true
class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :api_key
      t.integer :status
      t.string :avatar_url

      t.timestamps
    end
  end
end
