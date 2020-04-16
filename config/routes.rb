Rails.application.routes.draw do
  devise_for :users,  defaults: { format: :json }, controllers: 
  {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  # post '/login', to: 'sessions#create'
  # delete '/logout', to: 'sessions#destroy'
  # get '/logged_in', to: 'sessions#is_logged_in?'
  
  root to: 'users#index'
  resources :users, only: [:create, :show, :index]
end
