Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :bookmarks, only: [:index, :create, :destroy]
  resources :donations, except: [:edit]
  resources :podcasts, only: [:create]
  post 'podcast/find', to: 'podcasts#find', as: :podcast_find
end
