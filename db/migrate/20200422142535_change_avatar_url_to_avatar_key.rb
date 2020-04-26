# typed: true
class ChangeAvatarUrlToAvatarKey < ActiveRecord::Migration[6.0]
  def change
    remove_column :profiles, :avatar_url
    add_column :profiles, :avatar_key, :string
  end
end
