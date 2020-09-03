# typed: true
class StatusUpgradePushNoWorker
  include Sidekiq::Worker

  def perform(profile_id)
    profile = Profile.includes(:friends).find(profile_id)
    # return if old_updated_at and (DateTime.parse(old_updated_at) + 5.minutes)
    push_recipients = []
    profile.friends.each do |friend|
      next unless friend.status['color'] == 3
      next unless friend.user.push_token

      push_recipients << friend.user.push_token
    end

    push_recipients.uniq!

    client = Exponent::Push::Client.new(gzip: true)

    return if push_recipients.empty?

    handler = client.send_messages([{
                                     to: push_recipients,
                                     title: "#{profile.name} upgraded their status",
                                     body: "#{COLOR_EMOJI[profile.status['color']]} #{profile.status['message']}",
                                     data: { is_status: true }
                                   }])
  end
end
