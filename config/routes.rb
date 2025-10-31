Rails.application.routes.draw do
  resources :teams do
    resources :clients, only: %i[index new create edit update destroy] do
      resources :user_clients, only: %i[new create destroy]
      resources :shifts, only: %i[index new create edit update destroy] do
        post :generate_monthly_shifts, on: :collection
      end
    end
  end

  resources :user_needs
  resources :user_clients
  resources :client_needs
  resources :user_teams

  root "home#index"

  resources :offices, only: %i[new create show edit update destroy]
  devise_for :users, controllers: { registrations: "users/registrations", invitations: "users/invitations" }
  resources :users, only: [ :index ]

  if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
