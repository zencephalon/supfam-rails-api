# typed: false
class RedoUsersAddProfiles < ActiveRecord::Migration[6.0]
  def change
    drop_table :seens
    drop_table :statuses
    drop_table :users

    create_table :users do |t|
      t.string :phone, unique: true
      t.string :name, unique: true
      t.string :password_digest
      t.string :api_key

      t.timestamps
    end

    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :avatar_url
      t.jsonb :status
      t.jsonb :location
      t.jsonb :seen

      t.timestamps
    end

    create_table :invitations do |t|
      t.references :family, null: false, foreign_key: true
      t.string :phone

      t.timestamps
    end

    create_table :phone_verifications do |t|
      t.string :token
      t.string :phone
      t.string :code
      t.boolean :verified

      t.timestamps
    end
  end
end
