class NewFriendNotificationWorker
  include Sidekiq::Worker

  def perform(from_profile_id, to_profile_id)
    from_profile = Profile.includes(:user).find(from_profile_id)
    to_profile = Profile.find(to_profile_id)

    return unless from_profile && to_profile

    return unless from_profile.user.push_token

    client = Exponent::Push::Client.new(gzip: true)
    client.send_messages([{
                           to: [from_profile.user.push_token],
                           title: 'You have new fam!',
                           body: "#{to_profile.name} is now your fam",
                           data: { is_new_fam: true, profile_id: to_profile.id }
                         }])
  end
end
