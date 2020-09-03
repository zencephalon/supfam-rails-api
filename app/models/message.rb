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
    profile.summary
  end

  def summary
    slice(:id, :profile_id, :conversation_id, :type, :message, :qid, :links, :data)
  end

  def notification_title
    "#{profile.name} #{COLOR_EMOJI[profile.status['color']]}"
  end

  def notification_body
    return 'Sent an image' if type == 1

    message
  end

  def add_reaction(profile_id, emoji)
    self.reactions = {} if reactions.nil?
    reactions[emoji] = [] if reactions[emoji].nil?
    reactions[emoji] = reactions[emoji] | [profile_id]
    MessageReactionsChannel.broadcast_to(conversation_id.to_s, { reactions: reactions, id: id })
    save
  end

  def remove_reaction(profile_id, emoji)
    self.reactions = {} if reactions.nil?
    reactions[emoji] = [] if reactions[emoji].nil?
    reactions[emoji] = reactions[emoji] - [profile_id]
    MessageReactionsChannel.broadcast_to(conversation_id.to_s, { reactions: reactions, id: id })
    save
  end

  def add_flag
    self.flag = true
    save
  end

  def add_links
    self.links = Twitter::TwitterText::Extractor.extract_urls_with_indices(message) if type == 0
  end
end
