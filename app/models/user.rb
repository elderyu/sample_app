class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :email_downcase # simpler: before_save {email.downcase!}
  before_create :create_activation_digest

  has_many :microposts, dependent: :destroy

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

  # check authentication with given token, example of metaprogramming
  # makes callback depending on arguments passed
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    digest.nil? ? false : BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    self.update(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token  = User.new_token
    self.update(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    Micropost.where("user_id = ?", id) # Micropost.where("user_id = ?", id)
  end

  private

    def email_downcase
      email.downcase!
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
