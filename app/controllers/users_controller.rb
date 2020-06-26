# typed: false
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def me
    render json: @current_user
  end

  def friends
    profile = @current_user.profiles.find_by(id: params[:profile_id])

    unless profile
      render json: []
      return
    end

    render json: profile.friends
    # render json: @current_user.friends
  end

  def friends_of_friends
    profile = @current_user.profiles.find_by(id: params[:profile_id])

    unless profile
      render json: []
      return
    end

    result = profile.friends.map(&:friends).flatten.uniq
    result.reject! { |friend| profile.friends.map(&:id).include? friend.id  }
    result.reject! { |friend| profile.id == friend.id  }

    render json: result
  end

  def get_push_token
    render json: { push_token: @current_user.push_token }
  end

  def set_push_token
    @current_user.push_token = params[:push_token]
    @current_user.save
    render json: {}
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
