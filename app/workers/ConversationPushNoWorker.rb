class ConversationPushNoWorker
  include Sidekiq::Worker

  def perform(conversation_id, message_id)
    message = Message.includes(:profile).find(message_id)
    return unless message
    conversation = Conversation.includes(conversation_memberships: { profile: :user }).find(conversation_id)
    return unless conversation

    conversation.update_with_message(message)

    push_recipients = []

    conversation.conversation_memberships.each do |membership|
      next if membership.profile_id == message.profile_id
      next if membership.profile.status["color"] == 0
      next unless membership.profile.user.push_token

      push_recipients << membership.profile.user.push_token
    end

    client = Exponent::Push::Client.new(gzip: true)

    return if push_recipients.empty?

    title = "#{message.profile.name} #{COLOR_EMOJI[message.profile.status["color"]]}"
    body = message.message
    handler = client.send_messages([{
      to: push_recipients,
      title: title,
      # TODO: handle non-text messages
      body: body,
      data: { message: message, title: title, body: body }
    }])

    logger.error handler.errors
    logger.info handler.receipt_ids

    # TODO: we have to check push ticket receipts to make sure we're not getting flagged
    # Do this in a delayed job later
    # client.verify_deliveries(handler.receipt_ids)
  end
end