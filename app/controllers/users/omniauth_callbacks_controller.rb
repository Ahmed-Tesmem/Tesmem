class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  respond_to :json
  
  def google_oauth2
    user = User.from_omniauth(request.env['omniauth.auth'])
    byebug
    if user.present?
      if user.persisted?
        render json: {status: 'email already exist'}
      else
        render json: user.errors
      end
    end
  end
  
  def facebook
    if request.env["omniauth.auth"].info.email.blank?
      redirect_to "api/users/auth/facebook?auth_type=rerequest&scope=email"
      return
    end
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.present?
      if user.persisted?
        render json: user
      else
        render json: user.errors
      end
    end
  end
  
  # def passthru
  #   # super do |format|
  #   #   format.json {resource.errors}
  #   # end
  # end
  # def failure
  #   redirect_to root_path
  # end
end