Rails.application.routes.draw do
  get 'home/index'
  devise_for :users
  resources :owner_products do 
    post "genrate_plan" ,on: :collection
  end

  resources :users 
    
  resources :customer_products
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
end