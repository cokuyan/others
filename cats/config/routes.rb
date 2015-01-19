Rails.application.routes.draw do
  resources :cats
  resources :cat_rental_requests # , only: [:create, :destroy, :new]
  root to: 'static_pages#home', as: 'home'
  patch 'cat_rental_requests/:id/approve', to: 'cat_rental_requests#approve', as: 'approve'
  patch 'cat_rental_requests/:id/deny', to: 'cat_rental_requests#deny', as: 'deny'
  resource :user
  resource :session
end
