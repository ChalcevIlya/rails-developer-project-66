# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  get '/auth/github', to: proc { [302, { 'Location' => '/auth/github/callback' }, []] }, as: :auth_request
  get '/auth/github/callback', to: 'web/auth#create', as: :callback_auth
  delete '/session', to: 'web/auth#destroy', as: :session

  namespace :api do
    resources :checks, only: %i[create]
  end

  resources :repositories, only: %i[index show new create] do
    resources :checks, only: %i[create show],
                       controller: 'repositories/checks'
  end
end
