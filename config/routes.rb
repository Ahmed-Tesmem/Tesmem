Rails.application.routes.draw do
  devise_for :users,  controllers: 
  {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }, 
  defaults: { format: :json } do
  end
  root to: 'welcome#index'
  resources :users, :only => [:show, :create, :update, :destroy]
end
