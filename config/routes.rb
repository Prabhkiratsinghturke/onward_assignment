Rails.application.routes.draw do
  namespace :webhook do
    resources :endpoints
  end
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  resources :webhook_endpoints
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "webhook/endpoints#index"
end
