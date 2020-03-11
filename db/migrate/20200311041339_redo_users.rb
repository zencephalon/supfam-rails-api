class RedoUsers < ActiveRecord::Migration[6.0]
  def change
    drop_table :users

    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :api_key
      t.string :avatar_url

      t.timestamps
    end
  end
end
