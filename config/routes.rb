Rails.application.routes.draw do
  devise_for :users
  root to: "trips#index"

  resources :trips do
    resources :destinations
    resources :availabilities, except: [:show]
  end
end
