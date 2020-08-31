class FriendInviteNotificationWorker
	include Sidekiq::Worker

	def perform(friend_invite_id)
		friend_invite = FriendInvite.find(friend_invite_id).includes(from_profile: [:user])

		from_profile = friend_invite.from_profile

    client = Exponent::Push::Client.new(gzip: true)

    client.send_messages([{
    	to: [from_profile.user.push_token],
    	title: "New request to be your fam",
    	body: "#{from_profile.name} wants to be your fam",
    	data: { is_request: true, from_profile_id: from_profile.id }
    }])
	end
end