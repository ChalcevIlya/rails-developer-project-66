# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  get '/auth/github/callback', to: 'sessions#create'
  delete '/session', to: 'sessions#destroy', as: :session

  resources :repositories, only: %i[index show new create] do
    resources :checks, only: %i[create show],
                       controller: 'repositories/checks'
  end
end
