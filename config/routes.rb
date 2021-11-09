Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #verb        to: "controller#action"

  # root to: "pages#home"
  # get '/contact', to: 'pages#contact'
  # get '/about', to: 'pages#about', as: :about_us
  # # INDEX Read all the races
  # get '/races', to: 'races#index'
  # # NEW
  # get '/races/new', to: 'races#new'
  # # SHOW
  # get '/races/:id', to: 'races#show'
  # # CREATE
  # post '/races', to: 'races#create'
  # # EDIT
  # get '/races/:id/edit', to: 'races#edit'
  # # UPDATE
  # patch '/races/:id', to: 'races#update'
  # # DELETE
  # delete'/races/:id', to: 'races#destroy'

  devise_for :users

  root to: 'pages#home'

  resources :races do
    resources :runners, only: [ :create ]
  end

  resources :profile, only: :index

  resources :intros, only: [ :new, :create, :edit, :update ]


end
