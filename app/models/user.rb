class User < ApplicationRecord
  require 'securerandom'

  devise :database_authenticatable, :registerable, :confirmable, :trackable,
  :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2 facebook]
  self.skip_session_storage = [:http_auth, :params_auth]
  
  
  validates_uniqueness_of :email
  
  
  def self.from_omniauth(auth)
    User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = SecureRandom.urlsafe_base64
      user.username = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid
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
  
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end