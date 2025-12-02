Rails.application.routes.draw do
  get "terms"
  get "privacy_policy"

  resources :rooms, only: [ :index, :show, :new, :create, :destroy ] do
    resources :messages, only: [ :create ]
  end

  root "home#index"
  resources :offices, only: %i[edit update]

  resources :teams, only: %i[index new create edit update destroy] do
    resources :users, only: %i[ index edit update destroy]
    resources :clients, only: %i[index new create edit update destroy] do
      resources :client_needs, only: %i[index new create destroy]
      resources :user_clients, only: %i[new create destroy]
      resources :shifts, only: %i[index new create edit update destroy] do
        post :generate_monthly_shifts, on: :collection
      end
    end
    resources :work_statuses, only: %i[index]
  end

  namespace :employee do
    resources :shifts, only: %i[index update]
  end

  devise_for :users, controllers: { registrations: "users/registrations", invitations: "users/invitations", omniauth_callbacks: "users/omniauth_callbacks" }
  # 二段階認証用ルート
  devise_scope :user do
    get  "users/two_factor_setup", to: "users/two_factor#setup"
    post "users/confirm_two_factor", to: "users/two_factor#confirm"
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # ルーティングDSLに従ってアプリケーションのルートを定義します https://guides.rubyonrails.org/routing.html

  # /up でヘルスステータスを公開し、アプリが例外なく起動した場合は200を、そうでない場合は500を返します。
  # ロードバランサーやアップタイムモニターがアプリの稼働状態を確認するために使用できます。
  get "up" => "rails/health#show", as: :rails_health_check

  # app/views/pwa/* から動的なPWAファイルをレンダリング
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
