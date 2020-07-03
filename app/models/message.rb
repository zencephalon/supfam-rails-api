# typed: false
class Message < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :conversation
  belongs_to :profile

  def profile_summary
    self.profile.summary
  end

  def summary
    slice(:id, :profile_id, :conversation_id, :type, :message, :qid)
  end
end
