Rails.application.routes.draw do
  # Authentication
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # API endpoints
  namespace :api do
    get 'places/autocomplete', to: 'places#autocomplete'
  end

  # Main resources
  resources :trips do
    member do
      get :join
      post :add_participant
    end

    resources :destinations do
      resources :votes, only: :create do
        delete :destroy, on: :collection
      end
    end

    resources :availabilities, except: :show
  end

  # Standalone resources
  resources :comments, only: [:create, :destroy]

  # Root path
  root to: "trips#index"
end
