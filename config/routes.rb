Rails.application.routes.draw do
  resources :shifts, only: [:create, :destroy]
  devise_for :employees, controllers: {
    registrations: 'employees/registrations',
    confirmations: 'employees/confirmations',
    sessions: 'employees/sessions'
  }

  devise_scope :employee do
    scope '/:office_slug', as: :office do
      get 'sign_in', to: 'employees/sessions#new', as: :sign_in
      post 'sign_in', to: 'employees/sessions#create'
      delete 'sign_out', to: 'employees/sessions#destroy'
    end
  end

  if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  scope '/:office_slug', as: :office do
    get 'shift', to: 'shifts#index'
  end

  root to: 'home#index'
end
