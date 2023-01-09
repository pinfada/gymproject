Rails.application.routes.draw do
  root 'home#index'
  #get 'credit_cards/get_token'
  
  #get 'profiles/index'
  #get 'gymhouses/show'
  #get 'home/index'

  devise_for :users
  #resources :profiles
  resources :payments
  resources :gymhouses, only: [:new, :create, :show]

  match 'profil/:id',      to: 'profiles#index', :as => :profil, via: 'get'
  #match '/gym_profil',    to: 'gymhouses#show', via: 'get'
  #match '/new_offers',    to: 'gymhouses#create', via: 'post'
  match '/home',           to: 'home#index', via: 'get'
  match '/about',          to: 'home#about', via: 'get'
  match '/credit_cards',   to: 'credit_cards#get_token', via: 'get'


  namespace :admin do
    resources :users
    resources :statuses
    resources :posts
    resources :connects
    resources :reservations, only: [:new, :create, :show]
    
    root to: "users#index"
  end

  resources :gymhouses, only: :show do
    resources :reservations, only: :new, controller: "gymhouses/reservations"
  end

  resources :users do
    member do
      get :following, :followers
    end
  end
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  resources :reservation_payments, only: :create

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
