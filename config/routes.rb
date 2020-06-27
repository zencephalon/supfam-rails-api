# typed: strict
Rails.application.routes.draw do
  # resources :profiles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'users/me', to: 'users#me'

  get 'push_token', to: 'users#get_push_token'
  put 'push_token/:push_token', to: 'users#set_push_token'

  put 'statuses/me', to: 'profiles#update_status'

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

  # friend invite

  post 'friend_invites/create', to: 'friend_invites#create'
  post 'friend_invites/cancel', to: 'friend_invites#cancel'
  get 'friend_invites/from/:from_profile_id', to: 'friend_invites#from'
  get 'friend_invites/to/:to_profile_id', to: 'friend_invites#to'
  post 'friend_invites/accept', to: 'friend_invites#accept'
  post 'friend_invites/decline', to: 'friend_invites#decline'

  # conversations

  get 'conversation_memberships/me', to: 'conversation_memberships#me'
  get 'conversations/:dmId/dmMembership', to: 'conversations#dmMembership'
  get 'conversations/:id/membership', to: 'conversations#membership'

  get 'conversations/profile/:to_profile_id', to: 'conversations#conversation_with_profile'


  # messages

  get 'message/:id', to: 'messages#show'

  post 'conversations/:id/read/:msgId', to: 'conversations#read'
  get 'conversations/:id/preview', to: 'conversations#preview'

  get 'conversations/:id/messages', to: 'conversations#messages'
  post 'conversations/:id/messages/profile/:from_profile_id', to: 'messages#send_message'

  post 'profiles/:from_profile_id/messages/profile/:to_profile_id', to: 'messages#send_message_to_profile'
end
