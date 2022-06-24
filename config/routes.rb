Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get '/sign_up/new', to: "registrations#new"
  post '/sign_up', to: "registrations#create"
end
