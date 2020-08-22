# typed: false
class SessionsController < ActionController::API
  # POST /login
  def login
    @user = User.find_by(name: session_params[:name]).try(:authenticate, session_params[:password])

    if @user
      render json: { token: @user.api_key, user: @user }
    else
      render json: { error: 'User name or password incorrect' }, status: :unauthorized
    end
  end

  def check_invite
    phone = params[:phone]

    # invite = Invitation.find_by(phone: phone)

    # unless invite || Rails.env.development?
    #   render json: { error: 'No invite code found' }, status: :unauthorized
    #   return
    # end

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

    if verification and (verification.code == code || (Rails.env.development? && code == "1111"))
      verification.verified = true
      verification.save
      render json: { success: true }
      return
    end

    render json: { error: 'Invalid code' }, status: :unauthorized
  end

  def register
    token = params[:token]
    verification = PhoneVerification.find_by(token: token)

    if !verification or !verification.verified
      render json: { error: 'No verification found' }, status: :unprocessable_entity
      return
    end

    @user = User.new(user_params)
    @user.phone = verification.phone

    if @user.save
      render json: { token: @user.api_key, user: @user }, status: :created
    else
      render json: { error: @user.errors }, status: :unprocessable_entity
    end
  end

  def start_reset
    username = params[:username]

    user = User.find_by(name: username)

    unless user
      render json: { error: 'No user found' }, status: :not_found
      return
    end

    verification = ResetVerification.generate(user.id)
    TwMessager.send_message("Your Supfam password reset code: #{verification.code}")

    render json: { token: verification.token }
  end

  def resend_reset_code
    token = params[:token]
    verification = ResetVerification.find_by(token: token)

    if verification
      TwMessager.send_message(verification.phone, "Your Supfam password reset code: #{verification.code}")
    end

    render json: {}
  end

  def verify_reset
    token = params[:token]
    code = params[:code]

    verification = ResetVerification.find_by(token: token)

    if verification and (verification.code == code || (Rails.env.development? && code == "1111"))
      verification.verified = true
      verification.save
      render json: { success: true }
      return
    end

    render json: { error: 'Invalid code' }, status: :unauthorized
  end

  def reset_password
    token = params[:token]
    verification = ResetVerification.find_by(token: token)

    if !verification or !verification.verified
      render json: { error: 'No verification found'}, status: :unprocessable_entity
      return
    end

    user = verification.user
    user.update(password: params[:password]) 

    if user.save
      render json: { token: user.api_key, user: user }
    else
      render json: { error: user.errors }, status: :unprocessable_entity
    end
  end

  def available
    name = (params[:name] || '').downcase

    if ['here', 'free', 'busy', 'away', 'open'].include?(name) or !(name =~ /\A\w+\z/)
      render json: false
      return
    end

    user_with_name = User.find_by(name: name)
    if user_with_name
      render json: false
      return
    end

    render json: true
  end

  private

  def session_params
    params.permit(:name, :password)
  end

  def user_params
    params.permit(:name, :phone, :password, :password_confirmation)
  end
end