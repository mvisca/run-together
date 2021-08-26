Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #verb        to: "controller#action"
  root to: "pages#home"
  get '/about', to: 'pages#about', as: :about_us
  # the as: :custom_route is usable with link_to
  # The url shown in the browser will be the html file name
  get '/contact', to: 'pages#contact'
  get '/new_race', to: 'pages#new_race'
end
