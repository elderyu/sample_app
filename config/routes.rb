Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  #get '/home', to: 'static_pages#home'
  get '/help',       to: 'static_pages#help'
  get '/about',      to: 'static_pages#about'
  get '/contact',    to: 'static_pages#contact'
  get '/test',       to: 'static_pages#test'
  get '/signup',     to: 'users#new'
  post '/signup',    to: 'users#create'
  get '/login',      to: 'sessions#new'
  post '/login',     to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :users do
    member do
      get :following, :followers # arranges get requests for user/1/followers and user/1/following
    end
  end
  resources :account_activations, only: [:edit]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
