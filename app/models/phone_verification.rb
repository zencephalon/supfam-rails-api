# typed: true
class PhoneVerification < ApplicationRecord
  def self.generate_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless exists?(token: token)
    end
  end

  def self.generate_code
    (Array.new(4) {rand(10)}).join('')
  end

  def self.generate(phone)
    create(phone: phone, token: generate_token, verified: false, code: generate_code)
  end
end
