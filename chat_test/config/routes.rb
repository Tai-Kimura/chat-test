Rails.application.routes.draw do
  resources :rooms, only: [:index]
  mount ActionCable.server => '/cable'
end
