class ConversationBroadcastWorker
  include Sidekiq::Worker

  def perform(conversation_id, message_id)
    message = Message.includes(:profile).find(message_id)
    return unless message
    conversation = Conversation.includes(conversation_memberships: { profile: :user }).find(conversation_id)
    return unless conversation

    conversation.update_with_message(message)

    push_messages = []

    conversation.conversation_memberships.each do |membership|
      next if membership.profile_id == message.profile_id
      next if membership.profile.status["color"] == 0
      next unless membership.profile.user.push_token

      push_messages << {
        to: membership.profile.user.push_token,
        title: "#{message.profile.name} sent a message",
        # TODO: handle non-text messages
        body: message.message,
        _displayInForeground: true,
        data: { message: message }
      }
    end

    client = Exponent::Push::Client.new(gzip: true)

    handler = client.send_messages(push_messages)

    puts handler.errors
    puts handler.receipt_ids

    # Do this in a delayed job later
    # client.verify_deliveries(handler.receipt_ids)
  end
end