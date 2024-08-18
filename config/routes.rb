Rails.application.routes.draw do
  resources :invoices, except: [:edit]
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "invoices#index"

  get '/login', to: 'sessions#index'
  post '/login', to: 'sessions#login'
  get 'logout', to: 'sessions#logout'
  get '/jobs/:id', to: 'jobs#show'
  post '/jobs', to: 'jobs#create'
end
