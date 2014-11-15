Rails.application.routes.draw do
  root 'search#index'
  post 'search/query'
end
