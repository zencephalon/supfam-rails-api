# typed: true
require 'twilio-ruby'

ACCOUNT_SID = ENV['TWILIO_ACCOUNT_SID']
AUTH_TOKEN = ENV['TWILIO_AUTH_TOKEN']

FROM = '+19386669393' # Your Twilio number

class TwMessager
  def self.send_message(phone, msg)

    client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)

    if Rails.env.development?
      return
    end
    
    client.messages.create(
      from: FROM,
      to: phone,
      body: msg
    )
  end
end