# typed: false
class Message < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :conversation
  belongs_to :profile

  def profile_summary
    self.profile
  end
end
