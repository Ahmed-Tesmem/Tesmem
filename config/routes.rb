Rails.application.routes.draw do
  devise_for :users, :controllers => {:sessions => 'users/sessions', :registrations => 'users/registrations',:omniauth_callbacks => "users/omniauth_callbacks"} 
  # devise_scope :user do
  #   get 'sign_in', to: 'users/sessions#new'
  #   get 'sign_up', to: 'users/registrations#create'
  # end
  resources :users
end
