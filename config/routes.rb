Rails.application.routes.draw do
   root "users#show"
   get "/login", to: "sessions#new"
   post "/login", to: "sessions#create"
end
