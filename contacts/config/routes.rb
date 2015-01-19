Contacts::Application.routes.draw do
  resources :users do
    resources :contacts, only: [:index, :new]
    resources :comments, only: [:delete]
  end
  resources :contacts, only: [:create, :edit, :show, :update, :destroy] do
    resources :comments, only: [:delete]
  end

  resources :contact_shares, only: [:create, :destroy] do
    resources :comments, only: [:delete]
  end

  resources :comments, only: [:create]
end
