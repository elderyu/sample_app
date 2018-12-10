class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {email.downcase!} # simpler: before_save {email.downcase!}

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)+\z/i
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 8}, allow_nil: true

  # returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  # returns a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # remembers a user in the db for use in persistent sessions
  def remember
    self.remember_token = User.new_token    # self because we want class' atribute, not a local variable
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  # check authentication with given token
  def authenticated? remember_token
    !self.remember_digest.nil? ? BCrypt::Password.new(self.remember_digest).is_password?(remember_token) : false
  end

  def forget
    update_attribute :remember_digest, nil
  end


end
