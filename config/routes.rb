Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :bookmarks, only: [:index, :create, :destroy]
  resources :donations, except: [:edit, :new]
  resources :podcasts, only: [:create]
  post 'podcast/find', to: 'podcasts#find', as: :find_podcast
  get 'episode/selection', to: 'episodes#selection', as: :select_episode
  post 'episodes/find', to: 'episodes#find', as: :find_episodes
  post 'donations/new', to: 'donations#new', as: :new_donation
end
