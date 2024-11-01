Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :trips do
    resources :destinations
    resources :availabilities, except: [:show]
  end
end
