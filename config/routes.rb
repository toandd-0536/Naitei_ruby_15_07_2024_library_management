Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "users#show"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"

    resources :books do
      resources :episodes
    end

    namespace :admin do
      resources :users
    end
  end

  match "*unmatched", to: "errors#render_404", via: :all
end
