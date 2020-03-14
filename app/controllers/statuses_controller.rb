class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :update, :destroy]

  # GET /statuses
  def index
    @statuses = Status.all

    render json: @statuses
  end

  # GET /statuses/1
  def show
    render json: @status
  end

  def my_status
    render json: @current_user.current_status
  end

  # POST /statuses
  def create
    # @status = Status.new(status_params)
    if status_params[:message].nil?
      @current_user.current_status.update(color: status_params[:color])
      render json: @current_user.current_status
    else
      @status = @current_user.statuses.new(status_params)

      @current_user.families.each do |family|
        FamilyChannel.broadcast_to(family, @status)
      end

      if @status.save
        render json: @status, status: :created, location: @status
      else
        render json: @status.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /statuses/1
  def update
    if @status.update(status_params)
      render json: @status
    else
      render json: @status.errors, status: :unprocessable_entity
    end
  end

  # DELETE /statuses/1
  def destroy
    @status.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def status_params
      params.require(:status).permit(:user_id, :color, :message)
    end
end
