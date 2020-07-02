class ConversationReceiptWorker
    include Sidekiq::Worker

    def perform()