# typed: true
class Conversation < ApplicationRecord
  extend T::Sig

  has_many :messages, -> { where(flag: nil) }
  has_many :conversation_memberships
  has_many :users, through: :conversation_memberships
  has_many :profiles, through: :conversation_memberships
  belongs_to :last_message, class_name: 'Message', foreign_key: 'last_message_id', optional: true

  sig { params(ids: T::Array[Integer]).returns(String)}
  def self.getDmId(ids)
    ids.map(&:to_i).sort.join(':')
  end

  sig {params(current_user_id: Integer, profile_id: Integer).returns(T.self_type)}
  def self.dmWith(current_user_id, profile_id)
    user_id = Profile.find(profile_id).user_id
    dmId = getDmId([user_id, current_user_id])
    dm = find_by(dmId: dmId)
    return dm if dm

    dm = T.let(nil, T.untyped)
    Conversation.transaction do
      dm = create(dmId: dmId)
      friendship = Friendship.where(from_user_id: current_user_id, to_user_id: user_id)[0]
      dm.add_conversation_member(user_id, profile_id)
      dm.add_conversation_member(current_user_id, friendship.from_profile_id)
    end

    dm
  end

  def add_conversation_member(user_id, profile_id, type = :member)
    conversation_memberships.create(user_id: user_id, profile_id: profile_id, type: type)
  end

  def add_conversation_member_by_profile(profile, type = :member)
    add_conversation_member(profile.user_id, profile.id, type)
  end

  def add_conversation_members_by_profiles(profiles, type = :member)
    profiles.each do |profile|
      add_conversation_member_by_profile(profile, type)
    end
  end

  def add_conversation_members_by_profile_ids(profile_ids, type = :member)
    profiles = Profile.where(id: profile_ids)

    add_conversation_members_by_profiles(profiles, type)
  end

  def remove_member_by_profile_id(profile_id)
    conversation_memberships.where(profile_id: profile_id).destroy_all
  end

  sig {params(msg: Message).void}
  def broadcast_message(msg)
    ConversationChannel.broadcast_to(id.to_s, { last_message: msg, id: id })
    MessageChannel.broadcast_to(id.to_s, { message: msg })
    nil
  end

  def update_with_message(msg)
    update(message_count: message_count + 1, last_message_id: msg.id, last_message_profile_id: msg.profile_id)
  end

  def add_message(from_profile_id, msg_params)
    return false unless from_profile_id

    msg = messages.create({ profile_id: from_profile_id, message: msg_params[:message], type: msg_params[:type], qid: msg_params[:qid], data: msg_params[:data] })
    broadcast_message(msg)

    if msg.save
      # update_with_message(msg)
      ConversationPushNoWorker.perform_async(id, msg.id)
      return msg
    end

    false
  end

  def message_page
    messages.order(id: :desc).limit(10)
  end

  def get_messages_with_cursor(cursor_id)
    return message_page unless cursor_id

    message_page.where('id < ?', cursor_id)
  end

  def get_messages_with_precursor(cursor_id)
    return message_page unless cursor_id

    message_page.where('id > ?', cursor_id)
  end

  def message_count
    messages.count
  end

  def summary
    summary = attributes
    summary['member_profile_ids'] = conversation_memberships.map(&:profile_id)
    summary
  end
end
