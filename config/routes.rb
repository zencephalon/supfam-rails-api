Rails.application.routes.draw do
  # resources :seens
  # resources :families
  # resources :statuses
  # resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'users/me', to: 'users#me'

  put 'statuses/me', to: 'statuses#create'
  get 'statuses/me', to: 'statuses#my_status'

  put 'seens/me', to: 'seens#create'

  post 'login', to: 'sessions#login'
  post 'register', to: 'sessions#register'
  get 'available/:name', to: 'sessions#available'

  get 'friends', to: 'users#friends'
end
