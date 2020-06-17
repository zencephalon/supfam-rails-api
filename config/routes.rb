# typed: strict
Rails.application.routes.draw do
  # resources :profiles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'users/me', to: 'users#me'

  put 'statuses/me', to: 'profiles#update_status'
  # get 'statuses/me', to: 'statuses#my_status'

  get 'profiles/me', to: 'profiles#me'
  get 'profiles/:id', to: 'profiles#show'
  post 'profiles', to: 'profiles#create'

  put 'seens/me', to: 'seens#create'

  get 'uploads/presigned', to: 'uploads#presign'

  post 'login', to: 'sessions#login'
  post 'register', to: 'sessions#register'
  post 'check_invite', to: 'sessions#check_invite'
  post 'verify', to: 'sessions#verify'
  post 'resend_code', to: 'sessions#resend_code'
  
  get 'username/available', to: 'sessions#available'

  get 'friends/:profile_id', to: 'users#friends'


  # conversations

  get 'conversation_memberships/me', to: 'conversation_memberships#me'
  get 'conversations/:dmId/dmMembership', to: 'conversations#dmMembership'
  get 'conversations/:id/membership', to: 'conversations#membership'

  get 'conversations/profile/:to_profile_id', to: 'conversations#conversation_with_profile'


  # messages

  get 'message/:id', to: 'messages#show'

  post 'conversations/:id/read', to: 'conversations#read'
  get 'conversations/:id/preview', to: 'conversations#preview'

  get 'conversations/:id/messages', to: 'conversations#messages'
  post 'conversations/:id/messages/profile/:from_profile_id', to: 'messages#send_message'

  post 'profiles/:from_profile_id/messages/profile/:to_profile_id', to: 'messages#send_message_to_profile'
end
