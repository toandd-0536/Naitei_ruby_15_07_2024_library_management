Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "users#show"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :books do
      resources :episodes do
        post "add_to_cart", on: :member
      end
    end

    namespace :admin do
      resources :users
    end
  end

  match "*unmatched", to: "errors#render404", via: :all
end
