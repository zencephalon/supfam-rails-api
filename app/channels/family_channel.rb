class FamilyChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    family = Family.find_by(id: params[:id])
    stream_for family
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
