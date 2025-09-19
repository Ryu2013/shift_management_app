Rails.application.routes.draw do
  resources :shifts, only: [:create, :destroy]

  devise_for :employees, controllers: {
    registrations: 'employees/registrations',
    confirmations: 'employees/confirmations',
    sessions: 'employees/sessions'
  }

  devise_scope :employee do
    get '/:office_slug/sign_in', to: 'employees/sessions#new', as: :office_sign_in
  end

  get '/:office_slug/shift', to: 'shifts#index', as: :office_shift

  root to: 'home#index'
end
