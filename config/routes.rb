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
end
