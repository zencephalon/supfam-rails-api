# typed: false
class User < ApplicationRecord
  has_secure_password

  validates :name, :phone, presence: true
  validates :name, :phone, uniqueness: true
  validates :password, confirmation: true, length: { minimum: 8 }, if: :password
  validates :name, format: { with: /\A\w+\z/, message: "Ony allow letters, numbers, and underscores" }

  has_many :profiles
  has_many :conversation_memberships
  has_many :conversations, through: :conversation_memberships
  has_many :friendships, foreign_key: :from_user_id
  has_many :friends, through: :friendships, source: :to_friend

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

  def create_profile(profile_params)
    is_first_profile = (self.profiles.size < 1)

    profile_params[:is_default] = is_first_profile
    profile = self.profiles.create(profile_params)

    return profile
  end

  def dms
    self.friend_ids.map do |user_id|
      Conversation.dmWith(self.id, user_id)
    end
  end

  def get_friend_id_from_dm_id(dmId)
    ids = dmId.split(':').map(&:to_i)
    return ids.reject {|id| id == self.id}.first
  end

  def dms_by_dm_id
    dm_obj = {}
    self.direct_conversations.each do |conversation|
      # dm_obj[self.get_friend_id_from_dm_id(conversation.dmId)] = conversation
      dm_obj[conversation.dmId] = conversation
    end
    return dm_obj
  end

  def summary
    return {id: self.id, name: self.name, avatar_url: self.avatar_url}
  end

  # Assign an API key on create
  before_create do |user|
    user.name = user.name.downcase
    user.api_key = user.generate_api_key
  end

  def group_conversations
    self.conversations.where(dmId: nil).includes(:conversation_memberships).map(&:summary)
  end

  # after_create do |user|
  #   user.statuses.create({ message: 'I just joined, so everyone please welcome me! Sup fam?', color: 3 })
  # end
end
