json.(user, :username, :email, :password)
json.token user.generate_jwt
