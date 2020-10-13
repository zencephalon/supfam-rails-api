# typed: true
class ConversationPushNoWorker
  include Sidekiq::Worker

  def normal_messages(conversation, message, push_recipients)
    is_dm = !!conversation.dmId
    title = message.notification_title
    subtitle = is_dm ? nil : conversation.name
    body = message.notification_body

    return {
      to: push_recipients,
      title: title,
      # subtitle: subtitle,
      body: body,
      priority: 'high',
      channelId: 'minor',
      sound: "default",
      data: { message: message, title: title, body: body, isDm: is_dm, subtitle: subtitle, vibrate: true, priority: 'high' }
    }
  end

  def mention_messages(conversation, message, push_recipients)
    is_dm = !!conversation.dmId
    title = message.notification_title + ' @mentioned you'
    subtitle = is_dm ? nil : conversation.name
    body = message.notification_body

    return {
      to: push_recipients,
      title: title,
      # subtitle: subtitle,
      body: body,
      priority: 'high',
      channelId: 'minor',
      sound: "default",
      data: { message: message, title: title, body: body, isDm: is_dm, subtitle: subtitle, vibrate: true, priority: 'high' }
    }
  end

  def perform(conversation_id, message_id)
    message = Message.includes(:profile).find(message_id)
    return unless message

    conversation = Conversation.includes(conversation_memberships: { profile: :user }).find(conversation_id)
    return unless conversation

    normal_push_recipients = []
    mention_push_recipients = []

    conversation.conversation_memberships.each do |membership|
      next if membership.profile_id == message.profile_id

      user = membership.profile.user
      next unless user.push_token

      color = membership.profile.status['color']

      if message.mentioned_usernames.include?(user.name)
        # in a DM @mention can notify AWAY as a desperation measure
        # in groups @mention can notify BUSY
        mention_push_recipients.push(user.push_token) if conversation.dmId or color > 0
        # Skip the normal notification if we send an @mention notification
        next
      end

      ## Non-mentions

      # Don't notify AWAY
      next if color == 0

      # Don't notify BUSY for group conversations
      next if !conversation.dmId && color == 1

      normal_push_recipients << user.push_token
    end

    normal_push_recipients.uniq!

    client = Exponent::Push::Client.new(gzip: true)

    return if normal_push_recipients.empty? && mention_push_recipients.empty?

    notifications = []
    notifications.push(normal_messages(conversation, message, normal_push_recipients)) unless normal_push_recipients.empty?
    notifications.push(mention_messages(conversation, message, mention_push_recipients)) unless mention_push_recipients.empty?

    handler = client.send_messages(notifications)

    logger.error handler.errors
    logger.info handler.receipt_ids

    # TODO: we have to check push ticket receipts to make sure we're not getting flagged
    # Do this in a delayed job later
    # client.verify_deliveries(handler.receipt_ids)
  end
end
