Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "users#show"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"

    namespace :admin do
      resources :users
      resources :publishers
    end

    resources :books do
      resources :episodes do
        post "add_to_cart", on: :member
      end
    end

    resources :carts do
      collection do
        delete "delete_all"
      end
    end
  end

  match "*unmatched", to: "errors#render404", via: :all
end
