Rails.application.routes.draw do
  resources :users do
    get 'activate', on: :collection
  end
  resource :session # change to get 'login' to: 'sessions#new', etc
  root to: redirect('bands')
  resources :bands do
    resources :albums, only: :new
  end
  resources :albums, except: [:new, :index] do
    resources :tracks, only: :new
  end
  resources :tracks, except: [:new, :index]
  resources :notes, only: [:create, :update, :destroy]
end
