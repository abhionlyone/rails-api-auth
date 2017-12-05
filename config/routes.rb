Rails.application.routes.draw do
  scope module: :api, defaults: { format: :json }  do
    scope module: :v1 do
      post   'users/login'          => 'sessions#create'
      delete 'users/logout'         => 'sessions#destroy'
      post   'users/reset_password' => 'users#reset_password'
      resources :users, only: [:create, :destroy]
    end
  end
end
