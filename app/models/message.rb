# typed: false
class Message < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :conversation
  belongs_to :profile

  # types
  # 0 text
  # 1 image
  # unfortunately using an Enum here causes massive serialization problems, so we're sticking to an int

  def profile_summary
    self.profile.summary
  end

  def summary
    slice(:id, :profile_id, :conversation_id, :type, :message, :qid)
  end

  def notification_title
    "#{self.profile.name} #{COLOR_EMOJI[self.profile.status["color"]]}"
  end

  def notification_body
    return "Sent an image" if self.type == 1

    return self.message
  end
end
