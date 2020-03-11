class User < ApplicationRecord
  has_secure_password

  has_and_belongs_to_many :families

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

  # Assign an API key on create
  before_create do |user|
    user.api_key = user.generate_api_key
  end
end
