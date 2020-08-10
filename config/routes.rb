Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id", to: "cart#remove_single_item"
  put "/cart/:item_id", to: "cart#add_single_item"

  resources :orders, except: [:edit, :destroy, :index]

  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  namespace :admin do
    get "/dashboard", to: "dashboard#index"
    get "/", to: "dashboard#index"
    resources :users, only: [:index, :show]
    patch "/orders/:id", to: "orders#update"
    resources :merchants, only: [:index, :update, :show]
  end

  namespace :merchant do
    get "/dashboard", to: "dashboard#index"
    get "/", to: "dashboard#index"
    get "/orders/:order_id", to: "orders#show"
    resources :items, except: [:show]
    match "/items/:item_id/toggle_active", :to => "items#toggle_active", :as => 'merchant_item_active', :via => :patch
    resources :discounts, except: [:show]
  end

  namespace :profile do
    resources :orders, only: [:index, :show, :update]
    patch "/password", to: "passwords#update"
    get "/password/edit", to: "passwords#edit"
  end
end
