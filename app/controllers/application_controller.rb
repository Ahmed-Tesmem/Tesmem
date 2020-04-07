# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user
  
  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:id, :username, :email, :password, :provider, :uid)
    end
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:id, :username, :email, :password, :provider, :uid)
    end
  end
  
  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up) do, [:id, :username, :email, :password, :provider, :uid])
  #   devise_parameter_sanitizer.permit(:sign_in, [:id, :username, :email, :password, :provider, :uid])
  # end
  
  def authenticate_user
    byebug
    if request.headers['Authorization'].present?
      authenticate_or_request_with_http_token do |token|
        begin
          jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
          @current_user_id = jwt_payload['id']
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          head :unauthorized
        end
      end
    end
  end
  
  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end
  
  def current_user
    byebug
    @current_user ||= super || User.find(@current_user_id)
  end
  
  def signed_in?
    byebug
    @current_user_id.present?
  end
end
