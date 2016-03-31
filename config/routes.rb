Rails.application.routes.draw do


  resources :shifts
  resources :metashifts
  root to: 'workshift#index'
  get '/users/get_all' => 'users#get_all', as: 'get_all_users'

  resources :users do
    collection { post :import }
  end
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  #get  'auth/failure' => 'sessions#failure'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  post '/users/confirm' => 'users#confirm_users', as: 'confirm_users'
  post '/users/upload' => 'users#upload', as: 'csv_upload'
  post '/users/add' => 'users#add_user', as: 'add_user'
  get '/users/:id' => 'users#profile', as: 'user_profile'
  get '/users/:id/edit' => 'users#edit_profile', as: 'edit_profile'

  get '/index' => 'workshft#index'
  
  
  get '/policies/new' => 'policies#new', as: 'new_policy'
  get '/policies/edit' => 'policies#edit', as: 'edit_policy'
  get '/policies/' => 'policies#show', as: 'policy'
  post 'policies/' => 'policies#create'
  put '/policies/' => 'policies#update'
  
  
end