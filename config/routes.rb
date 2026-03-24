# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  get '/auth/github/callback', to: 'sessions#create'
  delete '/session', to: 'sessions#destroy', as: :session

  resources :repositories, only: %i[index new create]
end
