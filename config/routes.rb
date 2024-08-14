Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "users#show"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"

    namespace :admin do
      resources :users
    end

    resources :books do
      resources :episodes
    end
  end

  match "*unmatched", to: "errors#render404", via: :all
end
