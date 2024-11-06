Rails.application.routes.draw do
  devise_for :users
  root to: "trips#index"

  resources :comments, only: [:create, :destroy]
  resources :votes, only: [:create, :destroy]

  resources :trips do
    resources :destinations
    resources :availabilities, except: [:show]
  end
end
