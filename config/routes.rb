Rails.application.routes.draw do
  root 'static_pages#top'

  resources :user_sessions, only: [:new, :create, :destroy]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: [:new, :create, :show]
  resources :posts do
    collection do
      post "upload_image"
    end
  end
end
