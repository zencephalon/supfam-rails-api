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

    dm = self.create(dmId: dmId)
    ConversationMembership.create(user_id: user_id, conversation_id: dm.id, type: 0)
    ConversationMembership.create(user_id: @current_user.id, conversation_id: dm.id, type: 0)
    
    return dm
  end

end
