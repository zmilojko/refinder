Rails.application.routes.draw do
  resources :categories

  resources :car_brands

  resources :manufacturers

  root 'search#index'
  post 'search/query'
end
