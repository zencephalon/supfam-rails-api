# typed: false
class Conversation < ApplicationRecord
  has_many :messages
  has_many :conversation_memberships
  has_many :users, through: :conversation_memberships
  has_many :profiles, through: :conversation_memberships
  belongs_to :last_message, class_name: "Message", foreign_key: "last_message_id", optional: true

  def self.getDmId(ids)
    ids.map(&:to_i).sort.join(":")
  end

  def self.dmWith(current_user_id, profile_id)
    user_id = Profile.find(profile_id).user_id
    dmId = getDmId([user_id, current_user_id])
    dm = self.find_by(dmId: dmId)
    return dm if dm

    Conversation.transaction do
      dm = self.create(dmId: dmId)
      friendship = Friendship.where(from_user_id: current_user_id, to_user_id: user_id)[0]
      dm.add_conversation_member(user_id, profile_id)
      dm.add_conversation_member(current_user_id, friendship.from_profile_id)
    end
    
    return dm
  end

  def add_conversation_member(user_id, profile_id)
    self.conversation_memberships.create(user_id: user_id, profile_id: profile_id, type: :member) 
  end

  def add_conversation_member_by_profile(profile)
    self.add_conversation_member(profile.user_id, profile.id)
  end

  def add_conversation_members_by_profiles(profiles)
    profiles.each do |profile|
      self.add_conversation_member_by_profile(profile)
    end
  end

  def add_conversation_members_by_profile_ids(profile_ids)
    profiles = Profile.where(id: profile_ids)

    self.add_conversation_members_by_profiles(profiles)
  end

  def remove_conversation_member_by_profile_id(profile_id)
    self.conversation_memberships.where(profile_id: profile_id).destroy_all
  end

  def broadcast_message(msg)
    # Do we need this? Can't we just do it the same way we do last_message?
    json = ActiveModelSerializers::Adapter::Json.new(
      MessageSerializer.new(msg)
    ).serializable_hash

    ConversationChannel.broadcast_to("#{self.id}", { last_message: msg, id: self.id })
    MessageChannel.broadcast_to("#{self.id}", json)
  end

  def update_with_message(msg)
    self.update(message_count: self.message_count + 1, last_message_id: msg.id, last_message_profile_id: msg.profile_id)
  end

  def add_message(from_profile, msg_params)
    return false unless from_profile

    msg = self.messages.create({ profile_id: from_profile.id, message: msg_params[:message], type: msg_params[:type], qid: msg_params[:qid] })
    self.broadcast_message(msg)

    if msg.save
      # update_with_message(msg)
      ConversationPushNoWorker.perform_async(self.id, msg.id)
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

  def summary
    summary = self.attributes
    summary['member_profile_ids'] = self.conversation_memberships.map(&:profile_id)
    return summary
  end
end
