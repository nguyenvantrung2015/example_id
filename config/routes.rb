
Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :registrations]
  root to: 'home#index'
  devise_scope :user do
    get    'login',  to: 'sessions#new',     as: :new_user_session
    post   'login',  to: 'sessions#create',  as: :user_session
    delete 'logout', to: 'sessions#destroy', as: :destroy_user_session

    get    '/sign_up/new', to: "registrations#new", as: :new_user_registration
    post   '/sign_up', to: "registrations#create"
  end

  get 'auth/facebook/callback', to: 'omniauth_callbacks#facebook'

end

