Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      post   'users/login'          => 'sessions#create'
      delete 'users/logout'         => 'sessions#destroy'
      post   'users/forgot_password' => 'users#forgot_password'
      post   'users/passwords/new' => 'users#new_password'
      resources :users, only: [:create]
    end
  end
end
