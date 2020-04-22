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

  get 'conversations/me', to: 'conversations#me'

  # messages

  get 'messages/user/:to_user_id', to: 'messages#messages_with_user'
  post 'messages/user/:to_user_id', to: 'messages#send_message_to_user'
end
