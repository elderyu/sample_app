class PasswordResetsController < ApplicationController
before_action :get_user, only: [:edit, :update]
before_action :valid_user, only: [:edit, :update]
before_action :check_expiration, only: [:edit, :update] #expired password token

  def new
  end

  def edit
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user && @user.reset_digest.nil?
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset confirmation."
      redirect_to root_path
    else
      flash[:danger] = "Email not found."
      render 'new'
    end
  end

  def update
    if params[:user][:password].empty? # because now only has secure password protects from passing empty password, (validates :password, presence: true, length: {minimum: 8}, allow_nil: true)
      @user.errors.add(:password, "can't be empty.")
      render 'edit'
    elsif @user.update(user_params) #successful update
      log_in @user
      flash[:success] = "Password has been changed."
      redirect_to @user
      @user.update_attribute(:reset_digest, nil)
    else
      render 'edit' # invalid password e.g. too short
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      redirect_to root_path unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Reset token expired."
        redirect_to new_password_reset_path
      end
    end

end
