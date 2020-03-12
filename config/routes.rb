Rails.application.routes.draw do
  resources :families
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    get 'me', to: 'users#me', on: :collection
    get 'friends', to: 'users#friends', on: :collection
  end

  put 'statuses/me', to: 'statuses#create'
  get 'statuses/me', to: 'statuses#my_status'
  resources :statuses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'login', to: 'sessions#login'
  post 'register', to: 'sessions#register'
  get 'available/:name', to: 'sessions#available'
  get 'friends', to: 'users#friends'
end
