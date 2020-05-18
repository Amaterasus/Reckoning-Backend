Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/validate", to: "users#validate"

  get "/usersGames/:id", to: "users#games"

  post "/register", to: "users#register"
  post "/login", to: "users#login"
end
