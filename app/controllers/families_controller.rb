class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :update, :destroy]

  def invite_user
  end

  def me
    render json: @current_user.families
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family
      @family = Family.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def family_params
      params.require(:family).permit(:name)
    end
end
