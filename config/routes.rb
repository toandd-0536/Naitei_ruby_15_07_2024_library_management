Rails.application.routes.draw do
  root "users#show"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      resources :users
      resources :publishers
    end
  end
end
