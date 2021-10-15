Rails.application.routes.draw do
  devise_for :users
  resources :posts do
    resources :comments, shallow: true
    member do
      put "like", to: "posts#like"
    end
  end
  root "posts#index"
  get "static_pages/index"
  get "privacy_policy", to: "static_pages#privacy_policy"
  
  get 'posts', to: 'posts#index'

  post 'comments/create/:post_id', to: 'comments#create', constraints: { post_id: /\d+/ }
  post 'comments/create/:post_id/replies/:parent_id', to: 'comments#create', constraints: { post_id: /\d+/, parent_id: /\d+/ }
end

