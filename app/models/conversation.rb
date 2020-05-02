# typed: false
class Conversation < ApplicationRecord
  has_many :messages
  has_many :users, through: :conversation_memberships

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

    MessageChannel.broadcast_to(self, json)
  end

  def add_message(current_profile_id, msg_params)
    return false unless @current_user.profiles.find(current_profile_id)

    msg = self.messages.create({ profile_id: current_profile_id, message: msg_params[:message], type: msg_params[:type] })

    if msg.save
      self.update(message_count: self.message_count + 1, last_message_id: msg.id, last_message_profile_id: current_profile_id)
      # MessageChannel.broadcast_to(self, { message: msg })
      self.broadcast_message(msg)
      return true
    end

    return false
  end

  def message_count
    self.messages.count
  end
end
