require 'data_mapper'
require 'dm-postgres-adapter'
require 'bcrypt'

class User

  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation

  property :id,       Serial
  property :username, String
  property :email,    String, format: :email_address, required: true
  property :password_digest, String, length: 60

  # User will only save if password and password_confirmation match.
  validates_confirmation_of :password
  validates_format_of :email, as: :email_address

  # We cannot directly store the input password to the database, so instead
  # store the hash (password_digest) which is encrypted from the original
  # password here using bcrypt:
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

end