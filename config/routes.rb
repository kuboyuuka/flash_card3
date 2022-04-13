Rails.application.routes.draw do
  get "posts/index" => "posts#index"
  get "login" => "users#login_form"
  post "login" => "users#login"

  get "logout" => "users#logout"
  
  post "users/create" => "users#create"

  get "users/index" => "users#index"
  get "signup" => "users#new"
  get "users/:id" => "users#show"

  get "posts/index" => "posts#index"
  get "search" => "posts#index"
  get "posts/tagmaster" => "posts#tagmaster"
  get "posts/wordmaster" => "posts#wordmaster"
  get "posts/flashcard" => "posts#flashcard"
  get "posts/ranking" => "posts#ranking"
  get "posts/new" => "posts#new"
  post "posts/create" => "posts#create"
  get "posts/:id/edit" => "posts#edit"
  get "posts/:id" => "posts#show"
  post "posts/:id/update" => "posts#update"
  get "posts/:id/destroy" => "posts#destroy"

  get "/"  => "home#top"
  get "about" => "home#about"
  get "main" => "home#main"
end
