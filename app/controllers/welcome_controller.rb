class WelcomeController < ApplicationController
  # GET /users
  def index  
    users = User.all
    users = users.map do |user|
      { id: user.id,
        username: user.username,
        email: user.email,
        confirmation_token: user.confirmation_token,
        created_at: user.created_at,
        updated_at: user.updated_at,
        provider: user.provider,
        uid: user.uid
      }
    end
    render json: { results: users }.to_json, status: :ok
  end
end
