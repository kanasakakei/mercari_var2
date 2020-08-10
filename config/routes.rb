Rails.application.routes.draw do


  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get 'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
  end

  root 'products#index'
  get 'test_products/create'

  resources :products do
    collection do
      get :search
    end
  end

  resources :categories, only: [:show]


  resources :users, only: :show
end

