class User < ApplicationRecord
  has_secure_password

  has_and_belongs_to_many :families
  has_many :statuses
  has_many :current_status, -> { order(created_at: :desc).limit(1) }, class_name: :Status

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

  def friends
    # FIXME: this causes an n+1 query when the serializer grabs :current_status from each user
    # but doing f.users.eager_load(:current_status) doesn't work
    self.families.eager_load(:users).map {|f| f.users.eager_load(:current_status)}.flatten.reject{|u| u.id == self.id}
  end

  # Assign an API key on create
  before_create do |user|
    user.api_key = user.generate_api_key
  end

  after_create do |user|
    user.statuses.create({ message: 'My first status', color: 0 })
  end
end
