# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json
  
  protected
  def current_user?
    @current_user ||= super || User.find(@current_user_id)
  end
  
  def signed_in?
    @current_user_id.present?
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(
        :username,
        :email,
        :password,
        :auth_type
      )
    end
    # devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
