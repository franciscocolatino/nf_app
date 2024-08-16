Rails.application.routes.draw do
  resources :invoices
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "users#index"

  get '/login', to: 'sessions#index'
  post '/login', to: 'sessions#login'
  get 'logout', to: 'sessions#logout'
  post '/jobs', to: 'jobs#create'
end
