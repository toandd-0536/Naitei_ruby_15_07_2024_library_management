Rails.application.routes.draw do
  devise_for :users
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "dashboard#index"
      resources :categories
      resources :books
      resources :users
      resources :episodes
      resources :publishers
      resources :authors
      resources :borrow_books, except: [:index] do
        collection do
          get "borrow"
          get "return"
          get "history"
          post "refresh"
        end
        member do
          patch "confirm"
          patch "cancel"
          patch "returned"
          patch "lost"
        end
      end
    end

    root "home#index"
    get "/search_ajax", to: "home#search_ajax"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :authors, only: :show

    resources :users

    resources :books do
      resources :episodes do
        post "add_to_cart", on: :member
      end
    end

    resources :episodes do
      resources :ratings
      collection do
        get "all"
      end
    end

    resources :carts do
      collection do
        delete "delete_all"
        get "checkout"
      end
    end

    resources :borrow_cards do
      resources :borrow_books
    end

    resources :favorites, only: [:index, :create, :destroy] do
      collection do
        get "books"
        get "authors"
      end
    end
  end

  match "*unmatched", to: "errors#render404", constraints: lambda { |req| !req.path.starts_with?("/rails/active_storage/") }, via: :all
end
