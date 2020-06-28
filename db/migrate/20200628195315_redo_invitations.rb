class RedoInvitations < ActiveRecord::Migration[6.0]
  def change
    drop_table :invitations
    create_table :invitations do |t|
      t.references :from_profile

      t.column :status, :integer, default: 0
      t.column :phone, :string, null: false

      t.timestamps
    end
  end
end
