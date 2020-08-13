# typed: strict
Rails.application.routes.draw do
  # resources :profiles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'users/me', to: 'users#me'

  get 'push_token', to: 'users#get_push_token'
  put 'push_token/:push_token', to: 'users#set_push_token'

  put 'statuses/me', to: 'profiles#update_status'
  put 'locations/me', to: 'profiles#update_location'

  get 'profiles/me', to: 'profiles#me'
  get 'profiles/:id', to: 'profiles#show'
  post 'profiles', to: 'profiles#create'

  get 'uploads/presigned', to: 'uploads#presign'

  post 'login', to: 'sessions#login'
  post 'register', to: 'sessions#register'
  post 'check_invite', to: 'sessions#check_invite'
  post 'verify', to: 'sessions#verify'
  post 'resend_code', to: 'sessions#resend_code'
  
  get 'username/available', to: 'sessions#available'

  get 'friends/:profile_id', to: 'users#friends'
  get 'friends_of_friends/:profile_id', to: 'users#friends_of_friends'
  post 'friends/block', to: 'friend_invites#block'

  # invitations
  
  get 'invitations/phone_lookup/:phone/:from_profile_id', to: 'friend_invites#phone_lookup'
  post 'invitations/create', to: 'invitations#create'

  # friend invites

  post 'friend_invites/create', to: 'friend_invites#create'
  post 'friend_invites/cancel', to: 'friend_invites#cancel'
  get 'friend_invites/from/:from_profile_id', to: 'friend_invites#from'
  get 'friend_invites/to/:to_profile_id', to: 'friend_invites#to'
  post 'friend_invites/accept', to: 'friend_invites#accept'
  post 'friend_invites/decline', to: 'friend_invites#decline'

  # conversations

  get 'conversation_memberships/me', to: 'conversation_memberships#me'
  # vestigial
  # get 'conversations/:dmId/dmMembership', to: 'conversations#dmMembership'
  get 'conversations/:id/membership', to: 'conversations#membership'

  get 'conversations/profile/:to_profile_id', to: 'conversations#conversation_with_profile'

  get 'group_conversations/me', to: 'conversations#groups'

  # messages

  get 'message/:id', to: 'messages#show'
  post 'message/:id/reactions/add', to: 'messages#add_reaction'
  post 'message/:id/reactions/remove', to: 'messages#remove_reaction'
  post 'message/:id/flag', to: "messages#flag"

  post 'conversations/create', to: 'conversations#create_with_members'

  post 'conversations/:id/read/:msgId', to: 'conversations#read'
  get 'conversations/:id/preview', to: 'conversations#preview'
  get 'conversations/:id', to: 'conversations#show'

  post 'conversations/:id/add_members', to: 'conversations#add_members'
  post 'conversations/:id/remove_member', to: 'conversations#remove_member'
  put 'conversations/:id/name', to: 'conversations#update_name'

  get 'conversations/:id/messages', to: 'conversations#messages'

  # TODO: this route naming sucks, we should just include from_profile_id in the post body
  post 'conversations/:id/messages/profile/:from_profile_id', to: 'messages#send_message'
end
