# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[sessions registrations]
  root to: 'home#index'
  devise_scope :user do
    get    'login',  to: 'sessions#new',     as: :new_user_session
    post   'login',  to: 'sessions#create',  as: :user_session
    delete 'logout', to: 'sessions#destroy', as: :destroy_user_session

    get    '/sign_up/new', to: 'registrations#new', as: :new_user_registration
    post   '/sign_up', to: 'registrations#create'
  end

  match 'auth/:provider/callback', to: 'omniauth_callbacks#callback', via: :get
end
