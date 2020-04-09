# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json
  
  # GET /resource/sign_in
  def new
    # super.tap do |user|
    #   user.to_json
    self.resource = User.find_by_email(sign_in_params[:email])
    clean_up_passwords(resource)
    render json: resource
    # end
  end
  # POST /resource/sign_in
  def create
    byebug
    @user = warden.authenticate!(sign_in_params)
    sign_in(user, @user)
    render json: {
      status: :success,
      data: [@user],
      errors: @user.errors
    }
    # yield resource if block_given?
    # respond_with resource do |format|
    # format.json :resource
    # end
    # user = User.find_by_email(sign_in_params[:email])
    # if user && user.valid_password?(sign_in_params[:password])
    #   # current_user = user
    #   render json: { users: { 'sessions' => [user] } }, status: :ok
    # else
    #   render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    # end
  end
end
