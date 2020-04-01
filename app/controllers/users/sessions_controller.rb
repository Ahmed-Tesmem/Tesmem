# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  # before_action :authenticate_user!
  
  # GET /resource/sign_in
  def new
    # self.resource = User.new(params)
    #  super
  end
  
  # POST /resource/sign_in
  def create
    user = User.find_by(email: params[:user][:email])
    if user
      if user.valid_password?(params[:user][:password]) 
        render json: user
      else
        render json: { errors: { message: 'Invalid Credentials'} }
      end
    end
  end
  
  protected
  
  def auth_hash
    request.env['omniauth.auth']
  end
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:username, :email, :password, :auth_type)
    end
  end
  
  def auth_options
    params.require(:user)
    {
      scope: resource_name,
      email: params[:user][:email],
      password: params[:user][:password]
    }
  end
end