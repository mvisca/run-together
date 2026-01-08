Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #verb        to: "controller#action"

  devise_for :user
  root to: 'pages#home'

  resources :profile, only: [:index, :show]
  resources :intros, only: [ :new, :create, :edit, :update ]

  resources :races do
    resources :runners, only: [ :create ]
  end

  # Custom profile update routes
  namespace :users do
    get 'edit_picture', to: 'profile_updates#edit_picture'
    patch 'update_picture', to: 'profile_updates#update_picture'

    get 'edit_information', to: 'profile_updates#edit_information'
    patch 'update_information', to: 'profile_updates#update_information'

    get 'edit_password', to: 'profile_updates#edit_password'
    patch 'update_password', to: 'profile_updates#update_password'
  end
end
