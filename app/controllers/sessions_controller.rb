require 'twilio-ruby'

ACCOUNT_SID = '***REMOVED***'
AUTH_TOKEN = '***REMOVED***'

FROM = '+19386669393' # Your Twilio number

class SessionsController < ActionController::API
  # POST /login
  def login
    @user = User.find_by(name: session_params[:name]).try(:authenticate, session_params[:password])

    if @user
      render json: { token: @user.api_key, user: @user }
    else
      render json: 'ILUVU', status: :unauthorized
    end
  end

  def verify
    to = params[:phone]

    invite = Invitation.find_by(phone: to)

    unless invite
      render json: { error: 'No invite code found' }, status: :unauthorized
    end

    client = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)

    client.messages.create(
      from: FROM,
      to: to,
      body: "Your Supfam verification code: 9397"
    )
  end

  def register
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def available
    render json: !User.find_by(name: params[:name])
  end

  private

  def session_params
    params.permit(:name, :password)
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end