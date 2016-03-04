module SessionsHelper


	# The sign_in method creates a new token and sets cookie equal to new token, 
	# the user's token is then updated with hashed token.
	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.digest(remember_token))
		self.current_user = user
	end

	# Retrieve the current user with the ||= operator
	# if the current user is already set, you should return that user, 
	# or you'll need to pull out the remember token from the cookie and 
	# search for it in your database to pull up the corresponding user
	def current_user
		remember_token = User.digest(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	# Set the current user
	def current_user=(user)
		@current_user = user
	end

	# 
	def signed_in?
		!current_user.nil?
	end

	# Sign the user out
	def sign_out
		current_user.update_attribute( :remember_token,
									   User.digest(User.new_remember_token ))
		cookies.delete(:remember_token)
		self.current_user = nil
	end
	
end
