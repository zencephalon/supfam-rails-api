class CreateStatuses < ActiveRecord::Migration[6.0]
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

    create_table :statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :color
      t.string :message

      t.timestamps
    end
  end
end
