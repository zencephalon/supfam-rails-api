class HardWorker
  include Sidekiq::Worker

  def perform(conversation_id, message_id)
    # do something
    conversation = Conversation.find(conversation_id) #.includes(conversation_memberships: [:user, :profile])
    return unless conversation
    message = Message.find(message_id)
    return unless message

    # conversation.broadcast
    conversation.update_with_msg(message)
  end
end