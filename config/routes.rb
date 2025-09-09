Rails.application.routes.draw do
  get 'sessions/new'
  root to: 'sessions#new'

  get 'signup', to: 'users#new'

  resources :users, only: %i[show create] do
    resources :attendances, only: %i[index create]
  end

  # 退勤ボタン
  namespace :attendances do
    post :finish, to: 'finish#create'
  end

  # 休憩開始/終了ボタン
  namespace :rests do
    post :start, to: 'start#create'
    post :finish, to: 'finish#create'
  end

  # Session用のルートティングを設定
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
