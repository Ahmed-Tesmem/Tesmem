json.(user, :id, :username, :email, :password, :provider, :uid)
json.token user.generate_jwt