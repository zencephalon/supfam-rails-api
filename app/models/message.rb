# typed: false
class Message < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :conversation
  belongs_to :user

  def user_summary
    return self.user.summary
  end
end
