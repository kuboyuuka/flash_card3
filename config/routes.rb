Rails.application.routes.draw do
  get 'practice/index'
  post 'practice/index'

  get 'searches/search'
  get "posts/index" => "posts#index"
  get "login" => "users#login_form"
  post "login" => "users#login"

  get "logout" => "users#logout"
  
  post "users/create" => "users#create"

  get "users/index" => "users#index"
  get "signup" => "users#new"
  get "users/:id" => "users#show"

  get "posts/index" => "posts#index"

  get "posts/wordmaster" => "posts#wordmaster"
  get "posts/ranking" => "posts#ranking"
  get "posts/new" => "posts#new"
  post "posts/create" => "posts#create"
  get "posts/:id/edit" => "posts#edit"
  get "posts/:id" => "posts#show"
  post "posts/:id/update" => "posts#update"
  get "posts/:id/destroy" => "posts#destroy"
  get "posts/:id/synonym" => "posts#synonym"
  get "search" => "posts#search"

  get "tags/index" => "tags#index"
  get "tags/tagmaster" => "tags#tagmaster"
  get "tags/new" => "tags#new"
  post "tags/create" => "tags#create"
  post "tags/:id/update" => "tags#update"
  get "tags/:id/edit" => "tags#edit"
  get "tags/:id/show" => "tags#show"
  get "tags/:id/destroy" => "tags#destroy"
  get "search" => "tags#search"

  get "workbooks/flashcard" => "workbooks#flashcard"
  get "workbooks/ready" => "workbooks#ready"
  get "workbooks/:id/new_flashcard" => "workbooks#new_flashcard"
  post "workbooks/:id/new_flashcard_js" => "workbooks#new_flashcard_js"
  post "workbooks/:id/new_flashcard_back" => "workbooks#new_flashcard_back"
  get "workbooks/choices" => "workbooks#choices"
  get "workbooks/continue" => "workbooks#continue"
  get "workbooks/:id/confirmation" => "workbooks#confirmation"
  get "workbooks/:id/judgement" => "workbooks#judgement"
  get "workbooks/ranking" => "workbooks#ranking"

  get "/"  => "home#top"
  get "about" => "home#about"
  get "main" => "home#main"
  
end
