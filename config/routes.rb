Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  namespace :admin do
    resources :users
  end
  root to: 'tasks#index'
  resources :tasks do
    # /tasks/new/confirmというURLをconfirm_newアクションに対応づける
    # confirm_new_task POST /tasks/new/confirm tasks#confitm_new
    # 参考: https://railsguides.jp/routing.html
    post :confirm, action: :confirm_new, on: :new
    post :import, on: :collection
  end
end
