class ConversationMembership < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :conversation
end
