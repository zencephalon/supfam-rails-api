Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'users/me', to: 'users#me'

  put 'statuses/me', to: 'statuses#create'
  get 'statuses/me', to: 'statuses#my_status'

  put 'seens/me', to: 'seens#create'

  post 'login', to: 'sessions#login'
  post 'register', to: 'sessions#register'
  post 'verify', to: 'sessions#verify'
  get 'available/:name', to: 'sessions#available'

  get 'friends', to: 'users#friends'

  get 'conversations/me', to: 'conversations#me'

  # messages

  get 'messages/user/:to_user_id', to: 'messages#messages_with_user'
  post 'messages/user/:to_user_id', to: 'messages#send_message_to_user'
end
