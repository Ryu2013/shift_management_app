Rails.application.routes.draw do
  resources :shifts, only: [:index, :create, :destroy]
  devise_for :employees

  authenticated :employee do
    root to: "shifts#index", as: :authenticated_root
  end

  root to: "home#index"
end
