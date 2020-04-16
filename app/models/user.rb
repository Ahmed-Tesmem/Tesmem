class User < ApplicationRecord
  require 'securerandom'

  devise :database_authenticatable, :registerable, :confirmable, :trackable,
  :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2 facebook]
  self.skip_session_storage = [:http_auth, :params_auth]
  
  
  validates_uniqueness_of :email
  
  def self.from_omniauth(auth_token)
    auth = auth_token.info
    User.where(provider: auth_token.provider, uid: auth_token.uid).first_or_create do |user|
      user.email = auth.email
      user.password = SecureRandom.urlsafe_base64
      user.username = auth.name
      user.provider = auth_token.provider
      user.uid = auth_token.uid
    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |data|
      if data == session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end
  
  # mail sender
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end