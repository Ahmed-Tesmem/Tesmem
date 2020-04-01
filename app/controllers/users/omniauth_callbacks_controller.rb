# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def google_oauth2
    @user = User.create_with_omniauth(request.env['omniauth.auth'])
    if @user.present?
      if @user.persisted?
        render json: @user
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) 
        User.create(session['devise.google_data'])
        render json: @user.errors.messages
      end
    end
  end
  
  def facebook
    if request.env["omniauth.auth"].info.email.blank?
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
      return
    end
    @user = User.create_with_omniauth(request.env["omniauth.auth"])
    if @user.present?
      if @user.persisted?
        render json: @user
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        # User.create(session['devise.facebook_data'])
        render json: @user.errors.messages
      end
    end
  end
  
  def passthru
    render status: 404, plain: "Not found. Authentication passthru."
  end
  
  # def failure
  #   redirect_to root_path
  # end
end
