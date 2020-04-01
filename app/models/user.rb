class User < ApplicationRecord
  # attr_accessor :email, :username, :password
  require 'securerandom'
  # has_secure_password
  
  devise :database_authenticatable, :registerable, :confirmable,
  :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2 facebook]
  
  # # facebook & Google Authentications
  def self.create_with_omniauth(auth)
    where(email: auth.info.email, provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end
  def self.from_omniauth(auth)
    where(uid: auth.uid).first do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end
  #  facebook session handler
  def self.new_with_session(params, session)
    super.tap do |user|
      if (data == session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"])
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  # mail sender
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end