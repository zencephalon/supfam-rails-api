class User < ApplicationRecord
  has_secure_password

  has_and_belongs_to_many :families
  has_many :statuses

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

  def current_status
    self.statuses.last
  end

  def friends
    self.families.map {|f| f.users}.flatten.reject{|u| u.id == self.id}
  end

  # Assign an API key on create
  before_create do |user|
    user.api_key = user.generate_api_key
  end

  after_create do |user|
    user.statuses.create({ message: 'My first status', color: 0 })
  end
end
