# typed: false
class Conversation < ApplicationRecord
  has_many :messages
  has_many :conversation_memberships
  has_many :users, through: :conversation_memberships
  belongs_to :last_message, class_name: "Message", foreign_key: "last_message_id"

  def self.getDmId(ids)
    ids.map(&:to_i).sort.join(":")
  end

  def self.dmWith(current_user_id, profile_id)
    user_id = Profile.find(profile_id).user_id
    dmId = getDmId([user_id, current_user_id])
    dm = self.find_by(dmId: dmId)
    return dm if dm

    Conversation.transaction do
      dm = self.create!(dmId: dmId)
      ConversationMembership.create!(user_id: user_id, conversation_id: dm.id, type: 0)
      ConversationMembership.create!(user_id: current_user_id, conversation_id: dm.id, type: 0)
    end
    
    return dm
  end

  def broadcast_message(msg)
    json = ActiveModelSerializers::Adapter::Json.new(
      MessageSerializer.new(msg)
    ).serializable_hash

    MessageChannel.broadcast_to("#{self.id}", json)
  end

  def add_message(from_profile, msg_params)
    return false unless from_profile

    msg = self.messages.create({ profile_id: from_profile.id, message: msg_params[:message], type: msg_params[:type], qid: msg_params[:qid] })

    if msg.save
      self.update(message_count: self.message_count + 1, last_message_id: msg.id, last_message_profile_id: from_profile.id)
      self.broadcast_message(msg)
      return msg
    end

    return false
  end

  def message_page
    return self.messages.order(id: :desc).limit(10)
  end

  def get_messages_with_cursor(cursor_id)
    unless cursor_id
      return message_page
    end

    return self.message_page.where("id < ?", cursor_id)
  end

  def message_count
    self.messages.count
  end
end
