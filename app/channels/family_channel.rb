class FamilyChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "family_#{params[:name]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
