Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'experts#index'
  resources :experts do
    member do 
      get 'manage_friends'
    end
  end
  
  resources :friendships, only: [:create, :destroy]
end
