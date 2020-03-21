class Conversation < ApplicationRecord
  has_many :messages
  has_many :users, through: :conversation_memberships

  def self.getDmId(ids)
    [ids].sort.join(":")
  end

  def self.dmWith(user_id)
    dmId = getDmId([user_id, @current_user.id])
    dm = self.find_by(dmId: dmId)
    return dm if dm

    Conversation.transaction do
      dm = self.create!(dmId: dmId)
      ConversationMembership.create!(user_id: user_id, conversation_id: dm.id, type: 0)
      ConversationMembership.create!(user_id: @current_user.id, conversation_id: dm.id, type: 0)
    end
    
    return dm
  end

  def add_message(msg_params)
    msg = Message.new(msg_params)

    if msg.save
      self.update(message_count: self.message_count + 1, last_message_id: msg.id, last_message_user_id: @current_user.id)
      return true
    end

    return false
  end

  def message_count
    self.messages.count
  end
end
