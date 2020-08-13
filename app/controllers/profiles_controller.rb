# typed: false
class ProfilesController < ApplicationController
  # before_action :set_profile, only: [:show, :update, :destroy]

  def me
    profiles = @current_user.profiles

    render json: profiles
  end

  # GET /profiles/1
  def show
    # profile = @current_user.profiles.find_by(id: params[:id])
    # TODO, fix security on this, should only view friends
    profile = Profile.find_by(id: params[:id])
    render json: profile
  end

  def update_status
    profile = @current_user.profiles.find_by(id: params[:profileId])

    if profile && profile.update_status(status_params)
      render json: true
      return
    end

    render json: { error: "Couldn't update status" }, status: :unprocessable_entity
  end

  def update_location
    profile = @current_user.profiles.find_by(id: params[:profileId])

    if profile && profile.update_location(location_params)
      render json: true
      return
    end

    render json: { error: "Couldn't update status" }, status: :unprocessable_entity
  end

  # PUT /profiles/:id
  def update
    profile = @current_user.profiles.find_by(id: params[:id])

    if profile && profile.update(profile_params)
      render json: true
      return
    end

    render json: { error: "Couldn't update profile" }, status: :unprocessable_entity
  end


  # POST /profiles
  def create
    @profile = @current_user.create_profile(profile_params)

    if @profile.save
      render json: @profile, status: :created
    else
      render json: @profile.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def profile_params
      params.require(:profile).permit(:name, :avatar_key)
    end

    def status_params
      params.permit(:message, :color)
    end

    def location_params
      params.permit(:longitude, :latitude)
    end
end
