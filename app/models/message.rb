class Message < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :conversation
  belongs_to :user

  def user_summary
    user = self.user
    return {id: user.id, name: user.name, avatar_url: user.avatar_url}
  end
end
