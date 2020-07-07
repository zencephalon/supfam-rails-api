# typed: true
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
      next unless membership.profile.user.push_token

      color = membership.profile.status["color"]
      # Don't notify AWAY
      next if color == 0
      # Don't notify BUSY for group conversations
      next if !conversation.dmId && color == 1

      push_recipients << membership.profile.user.push_token
    end

    push_recipients.uniq!

    client = Exponent::Push::Client.new(gzip: true)

    return if push_recipients.empty?

    isDm = !!conversation.dmId
    title = message.notification_title
    subtitle = isDm ? nil : conversation.name
    body = message.notification_body
    handler = client.send_messages([{
      to: push_recipients,
      title: title,
      # subtitle: subtitle,
      body: body,
      data: { message: message, title: title, body: body, isDm: isDm, subtitle: subtitle }
    }])

    logger.error handler.errors
    logger.info handler.receipt_ids

    # TODO: we have to check push ticket receipts to make sure we're not getting flagged
    # Do this in a delayed job later
    # client.verify_deliveries(handler.receipt_ids)
  end
end