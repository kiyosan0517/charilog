Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  
  root 'static_pages#top'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms', to: 'static_pages#terms'

  resources :user_sessions, only: %i[create destroy]
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[index new create show] do
    resource :relationships, only: %i[create destroy]
    member { get 'follows', 'followers' }
  end

  resource :profile, only: %i[edit update] do 
    resources :attachments, controller: 'profile/attachments', only: %i[destroy]
  end

  resources :posts do
    resource :like, only: %i[create destroy]
    get 'likes', on: :collection
    get 'search_rakuten', on: :collection
    post 'upload_image', on: :collection
  end

  resources :items, only: %i[index]
  get 'items/search' => 'items#search'

  resources :password_resets, only: %i[new create edit update]
end
