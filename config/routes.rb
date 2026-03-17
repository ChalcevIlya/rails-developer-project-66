Rails.application.routes.draw do
  root "home#index"

  get "/auth/github/callback", to: "sessions#create"
  delete "/session", to: "sessions#destroy", as: :session

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
