Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/validate", to: "users#validate"

  post "/avatar", to: "users#avatar"

  post "/register", to: "users#register"
  post "/login", to: "users#login"
end
