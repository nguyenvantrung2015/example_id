# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[sessions registrations]
  root to: 'home#index'
  devise_scope :user do
    get    'login',  to: 'sessions#new', as: :new_user_session
    post   'login',  to: 'sessions#create',  as: :user_session
    delete 'logout', to: 'sessions#destroy', as: :destroy_user_session

    get    '/sign_up/new', to: 'registrations#new', as: :new_user_registration
    post   '/sign_up', to: 'registrations#create'
  end

  get 'webauthn', to: 'webauthn_assertions#index'
  post 'webauthn/assertions/options', to: 'webauthn_assertions#options'
  post 'webauthn/assertions', to: 'webauthn_assertions#create'

  match 'auth/:provider/callback', to: 'omniauth_callbacks#callback', via: :get

  resources :webauthn_credentials, path: 'webauthn/credentials' do
    collection do
      post :options
    end
  end
end
