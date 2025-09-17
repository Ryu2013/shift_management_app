Rails.application.routes.draw do
  resources :shifts, only: [:index, :create, :destroy]

  devise_for :employees, controllers: {
    registrations: 'employees/registrations',
    confirmations: 'employees/confirmations',
    sessions: 'employees/sessions'
  }

  devise_scope :employee do
    get '/:office_slug/sign_in', to: 'employees/sessions#new', as: :office_sign_in
  end

  authenticated :employee do
    root to: 'shifts#index', as: :authenticated_root
  end

  root to: 'home#index'
end
