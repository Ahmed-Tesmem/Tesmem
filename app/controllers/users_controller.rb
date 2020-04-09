# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_user!
  
  def new
    user = User.new(user_params)
    if user
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end
  # GET /users/1
  def show
    render json: user
  end
  
  # POST /users
  def create
    user = User.new(user_params)
    if user.save!
      render json: { user: [user] }, status: :created#, location: @user
    else
      render json: { errors: [user.errors] }, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /users/1
  def update
    if current_user.update_attributes(user_params)
      render :show
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end
  
  # DELETE /users/1
  def destroy
    user.destroy
  end
  
  private 
  def set_user
    user = User.find(user_params[:email])
  end
  
  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:id, :username, :email, :password, :provider, :uid)
  end
end

