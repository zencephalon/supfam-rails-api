require 'twilio-ruby'

ACCOUNT_SID = '***REMOVED***'
AUTH_TOKEN = '***REMOVED***'

FROM = '+19386669393' # Your Twilio number

class TwMessager
  def self.send_message(phone, msg)

    client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)

    client.messages.create(
      from: FROM,
      to: phone,
      body: msg
    )
  end
end