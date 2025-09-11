Rails.application.routes.draw do
  get 'sessions/new'
  root to: 'sessions#new'

  get 'signup', to: 'users#new'

  # users#showのparamsをuser_idに設定
  get 'users/:user_id', to: 'users#show', as: 'user'
  post 'users', to: 'users#create', as: 'users'

  resources :users, only: [] do
    resources :attendances, only: %i[index create]
    # 退勤
    post 'attendances/finish', to: 'attendances/finish#create', as: :attendances_finish

    # 休憩開始/終了
    post 'rests/start',  to: 'rests/start#create',  as: :rests_start
    post 'rests/finish', to: 'rests/finish#create', as: :rests_finish
  end

  # Session用のルートティングを設定
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
