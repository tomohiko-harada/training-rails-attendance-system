Rails.application.routes.draw do
  get 'sessions/new'
  resources :tasks
  root to: "sessions#new"

  get "signup", to: "users#new"
  resources :users, only: [:show, :create]

  # Session用のルートティングを設定
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

end
