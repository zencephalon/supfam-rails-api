class SeenChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    puts "============= CONNECTED ============"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "============= DISCONNECTED ============"
  end

  def update_seen(msg)
    puts msg
    current_user.update_seen(msg['data'])
    current_user.broadcast_update
  end
end
