Rails.application.routes.draw do
  resources :products

  resources :categories

  resources :car_brands

  resources :manufacturers

  root 'search#index'
  post 'search', to: 'search#query'
end
