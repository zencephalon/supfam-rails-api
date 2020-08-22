class CreateResetVerifications < ActiveRecord::Migration[6.0]
  def change
    create_table :reset_verifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :code
      t.string :token
      t.boolean :verified

      t.timestamps
    end
  end
end
