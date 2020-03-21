class User < ApplicationRecord
  has_secure_password

  has_and_belongs_to_many :families
  has_many :statuses
  has_many :seens
  belongs_to :current_status, class_name: :Status
  belongs_to :current_seen, class_name: :Seen

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

  def update_status(status_params)
    if self.current_status
      self.current_status.update(status_params)
    else
      status = self.statuses.create(status_params)
      self.current_status_id = status.id
      self.save
    end
    return self.current_status
  end

  def update_seen(seen_params)
    if self.current_seen
      self.current_seen.update(seen_params)
      self.current_seen.touch
    else
      seen = self.seens.create(seen_params)
      self.current_seen_id = seen.id
      self.save
    end
  end

  def broadcast_update
    json = ActiveModelSerializers::Adapter::Json.new(
      UserSerializer.new(self)
    ).serializable_hash

    self.families.each do |family|
      FamilyChannel.broadcast_to(family, json)
    end
  end

  def friends
    self.families.eager_load(:users).map {|f| f.users.eager_load(:current_status, :current_seen)}.flatten.reject{|u| u.id == self.id}
  end

  def friend_ids
    self.families.eager_load(:users).map {|f| f.users}.flatten.map {|u| u.id}
  end

  def dms
    self.friend_ids.map do |user_id|
      Conversation.dmWith(user_id)
    end
  end

  # Assign an API key on create
  before_create do |user|
    user.api_key = user.generate_api_key
  end

  after_create do |user|
    user.statuses.create({ message: 'I just joined, so everyone please welcome me! Sup fam?', color: 3 })
  end
end
