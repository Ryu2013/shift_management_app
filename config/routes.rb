Rails.application.routes.draw do
  resources :shifts, only: [:index, :create, :destroy]
  devise_for :employees
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
root to: "shifts#index"

  # Defines the root path route ("/")
  # root "articles#index"
end
