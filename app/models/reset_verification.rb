class ResetVerification < ApplicationRecord
  belongs_to :user

  def self.generate_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless exists?(token: token)
    end
  end

  def self.generate_code
    (Array.new(4) {rand(10)}).join('')
  end

  def self.generate(user_id)
    create(user_id: user_id, token: generate_token, verified: false, code: generate_code)
  end
end
