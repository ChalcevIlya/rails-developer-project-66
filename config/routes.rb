# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  post 'auth/:provider', to: 'web/auth#create', as: :auth_request
  get 'auth/:provider/callback', to: 'web/auth#create', as: :callback_auth
  delete '/session', to: 'web/auth#destroy', as: :session

  namespace :api do
    resources :checks, only: %i[create]
  end

  resources :repositories, only: %i[index show new create] do
    resources :checks, only: %i[create show],
                       controller: 'repositories/checks'
  end
end
