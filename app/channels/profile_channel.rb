# typed: true
class ProfileChannel < ApplicationCable::Channel
  def subscribed
  	current_user.friendships.pluck(:to_profile_id).each do |profile_id|
	    stream_for "#{profile_id}"
	  end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
