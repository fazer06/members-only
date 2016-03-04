# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string
#

class User < ActiveRecord::Base

	has_many :posts
	# Downcase the email and name attributes before saving the user
	before_save { self.email = email.downcase }
	before_save { self.name  = name.downcase }

	# Before the create action is run we need to create a remember token
	before_create :create_remember_token

	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }

	# Returns a random token when called from create_remember_token
	# See listing 8.31 of the rails tutorial for generating tokens.
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	# Returns the hash digest of the given string
	# See listing 8.32: Adding a remember method to the User model
	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private

		# Calls new_remember_token which is then passed to User.digest
		# which encrypts the token, and using self ensures that by assignment 
		# we set the user’s remember_token attribute in the database
		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end

end
