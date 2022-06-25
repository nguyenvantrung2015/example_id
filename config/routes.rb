Rails.application.routes.draw do
  # devise_for :users
  root to: 'home#index'
  get '/sign_up/new', to: "registrations#new"
  post '/sign_up', to: "registrations#create"
  devise_scope :user do
    get    'login',  to: 'sessions#new',     as: :new_user_session
    post   'login',  to: 'sessions#create',  as: :user_session
    delete 'logout', to: 'sessions#destroy', as: :destroy_user_session
  end
end
