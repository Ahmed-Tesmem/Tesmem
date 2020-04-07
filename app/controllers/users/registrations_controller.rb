# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  respond_to :json
  
  # GET /resource/sign_up
  def new
    self.resource = User.new_with_session
    render json: resource
  end
  
  # POST /resource
  def create
    byebug
    user = User.find_by_email(sign_up_params[:email])
    if user
      render json: { errors: { 'email' => [' is already taken'] } }, status: :unprocessable_entity
    else
      user = User.create(sign_up_params)
      render json: user, status: :created
    end
  end
  
  protected
  
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:id, :username, :email, :password, :provider, :uid)
    end
  end
  
  
  
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end
  
  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end
  
  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end