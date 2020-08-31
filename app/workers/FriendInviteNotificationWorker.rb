class FriendInviteNotificationWorker
	include Sidekiq::Worker

	def perform(friend_invite_id)
		friend_invite = FriendInvite.includes(to_friend: [:user], from_friend: []).find(friend_invite_id)

		from_profile = friend_invite.from_friend
		to_profile = friend_invite.to_friend

    client = Exponent::Push::Client.new(gzip: true)

    logger.info to_profile.user.push_token
    client.send_messages([{
    	to: [to_profile.user.push_token],
    	title: "New request to be your fam",
    	body: "#{from_profile.name} wants to be your fam",
    	data: { is_request: true, from_profile_id: from_profile.id }
    }])
	end
end