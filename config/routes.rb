Rails.application.routes.draw do
  resources :manufacturers

  root 'search#index'
  post 'search/query'
end
