require "sidekiq/web"

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "dashboard#index"
      resources :categories
      resources :books
      resources :users
      resources :episodes
      resources :publishers
      resources :authors
      resources :borrow_cards, only: [] do
        collection do
          get "/borrow", to: "borrow_cards#borrow_index"
          get "/return", to: "borrow_cards#return_index"
          get "/history", to: "borrow_cards#history_index"
          post "refresh"
        end
        member do
          get "borrow"
          get "return"
          get "history"
        end
      end
      resources :borrow_books, except: [:index] do
        collection do
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

    resources :users, only: %i(show update)

    devise_for :users, path: "auth", controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords"
    }, only: [:sessions, :registrations, :passwords]

    resources :authors, only: :show

    resources :books do
      resources :episodes do
        get "add_to_cart", on: :member
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

    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end
    
    namespace :api do
      namespace :v1 do
        namespace :admin do
          resources :episodes, only: %i(index create update destroy)
        end
      end
    end
  end

  match "*unmatched", to: "errors#render404", constraints: lambda { |req| !req.path.starts_with?("/rails/active_storage/") }, via: :all
end
