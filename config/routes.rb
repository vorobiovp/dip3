Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions', confirmations: 'users/confirmations', passwords: 'users/passwords', registrations: 'users/registrations', unlocks: 'users/unlocks' }
  resources :posts do
    
    resources :comments
    member do
      put "like", to: "posts#like"
    end
  end
  resources :tags
  
  root "posts#index"
  get "static_pages/index"
  get "privacy_policy", to: "static_pages#privacy_policy"
  
  get 'posts', to: 'posts#index'

end

