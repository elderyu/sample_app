#require 'byebug'
class UsersController < ApplicationController

  def new
    @user = User.new(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
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

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
