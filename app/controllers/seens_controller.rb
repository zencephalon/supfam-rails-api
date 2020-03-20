class SeensController < ApplicationController
  before_action :set_seen, only: [:show, :update, :destroy]

  # GET /seens
  def index
    @seens = Seen.all

    render json: @seens
  end

  # GET /seens/1
  def show
    render json: @seen
  end

  # POST /seens
  def create
    @current_user.update_seen(seen_params)
    @current_user.broadcast_update

    render json: true
  end

  # PATCH/PUT /seens/1
  def update
    if @seen.update(seen_params)
      render json: @seen
    else
      render json: @seen.errors, status: :unprocessable_entity
    end
  end

  # DELETE /seens/1
  def destroy
    @seen.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seen
      @seen = Seen.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def seen_params
      params.require(:seen).permit(:user_id, :network_type, :network_strength, :cellular_generation, :battery, :lat, :long, :client_type, :battery_state)
    end
end
