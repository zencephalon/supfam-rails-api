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

  def check_invite
    phone = params[:phone]

    invite = Invitation.find_by(phone: phone)

    unless invite
      render json: { error: 'No invite code found' }, status: :unauthorized
      return
    end

    verification = PhoneVerification.generate(phone)

    TwMessager.send_message(phone, "Your Supfam verification code: #{verification.code}")

    render json: { token: verification.token }
  end

  def resend_code
    token = params[:token]
    verification = PhoneVerification.find_by(token: token)

    if verification
      TwMessager.send_message(verification.phone, "Your Supfam verification code: #{verification.code}")
    end

    render json: {}
  end

  def verify
    token = params[:token]
    code = params[:code]

    verification = PhoneVerification.find_by(token: token)

    if verification and verification.code == code
      verification.verified = true
      verification.save
      render json: { success: true }
      return
    end

    render json: { error: 'Invalid code' }, status: :unauthorized
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