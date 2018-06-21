Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations/registrations' }
  root to: 'pages#home'
  resources :bookmarks, only: [:index, :create, :destroy]
  resources :donations, except: [:edit, :new, :destroy]
  resources :podcasts, only: [:create, :show]
  resources :episodes, only: [ :show, :index ]
  resources :users, only: [:show, :index]
  resources :notifications, only: [:index]
  get 'view/create/:id', to: 'views#create', as: :create_view
  post 'podcast/find', to: 'podcasts#find', as: :find_podcast
  post 'episodes/find', to: 'episodes#find', as: :find_episodes
  post 'donations/new', to: 'donations#new', as: :new_donation
  post 'follow/:id', to: 'users#toggle_follow', as: :toggle_follow
end
