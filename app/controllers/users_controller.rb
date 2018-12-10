#require 'byebug'
class UsersController < ApplicationController

  def new
    @user = User.new(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_url(@user) #also only @user is enough
    else
      render 'new'
      Rails::logger.debug "#{@user.errors.full_messages}"
    end

  end

  def show
    @user = User.find(params[:id])
    #byebug
  end

  def edit
    @user = User.find_by(params[:id])
  end

  def update
    @user = User.find_by(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
