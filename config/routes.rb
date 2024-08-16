Rails.application.routes.draw do
  resources :invoices
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "users#index"

  get '/login', to: 'login#index'
  post '/login', to: 'login#login'
  get 'logout', to: 'login#logout'
end
