Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  root to: "trips#index"

  resources :comments, only: [:create, :destroy]
  resources :votes, only: [:create, :destroy]

  resources :trips do
    get :join
    post :add_participant
    resources :destinations
    resources :availabilities, except: [:show]
  end

  namespace :api do
    get 'places/autocomplete', to: 'places#autocomplete'
  end
end
