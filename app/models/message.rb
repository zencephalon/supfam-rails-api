# typed: false
class Message < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :conversation
  belongs_to :profile

  before_save :add_links

  # types
  # 0 text
  # 1 image
  # 2 quoted reply
  # unfortunately using an Enum here causes massive serialization problems, so we're sticking to an int

  def profile_summary
    self.profile.summary
  end

  def summary
    slice(:id, :profile_id, :conversation_id, :type, :message, :qid, :links, :data)
  end

  def notification_title
    "#{self.profile.name} #{COLOR_EMOJI[self.profile.status["color"]]}"
  end

  def notification_body
    return "Sent an image" if self.type == 1

    return self.message
  end

  def add_reaction(profile_id, emoji)
    self.reactions = {} if self.reactions.nil?
    self.reactions[emoji] = [] if self.reactions[emoji].nil?
    self.reactions[emoji] = self.reactions[emoji] | [profile_id]
    self.save
  end

  def remove_reaction(profile_id, emoji)
    self.reactions = {} if self.reactions.nil?
    self.reactions[emoji] = [] if self.reactions[emoji].nil?
    self.reactions[emoji] = self.reactions[emoji] - [profile_id]
    self.save
  end

  def add_links
    if self.type == 0
      self.links = Twitter::TwitterText::Extractor.extract_urls_with_indices(self.message)
    end
  end
end
