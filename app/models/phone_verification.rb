class PhoneVerification < ApplicationRecord
  def self.generate_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless self.exists?(token: token)
    end
  end

  def self.generate_code
    (Array.new(4) {rand(10)}).join('')
  end

  def self.generate(phone)
    return self.create(phone: phone, token: self.generate_token, verified: false, code: self.generate_code)
  end
end
