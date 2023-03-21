Rails.application.routes.draw do

  root 'pages#home'

  resources :rooms do
    resources :messages 
  end
  
 
  resource :session, only: [:new, :create, :destroy]
  get "signin" => "sessions#new"
 

  resources :users
  get "signup" => "users#new"

  #get 'user/:id', to: 'users#show', as: 'user' possibly use slugs instead

  

 


end
