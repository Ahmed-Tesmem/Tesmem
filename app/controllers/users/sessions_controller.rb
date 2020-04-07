# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json
  
  # GET /resource/sign_in
  def new
    byebug
    super.tap do |user|
      user.to_json
      # self.resource = User.find(sign_in_params[:email])
      # clean_up_passwords(resource)
      # render json: resource
    end
  end
  # POST /resource/sign_in
  def create
    user = User.find_by_email(sign_in_params[:email])
    if user && user.valid_password?(sign_in_params[:password])
      current_user = user
      render json: { users: { 'sessions' => [user] } }, status: :ok
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end
end
