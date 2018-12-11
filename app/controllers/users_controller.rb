#require 'byebug'
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :index, :edit, :update]
  before_action :correct_user, only: [:show, :edit, :update]

  def new
    @user = User.new(params[:id])
  end

  def index
    @users = User.all
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
    @user = User.find(params[:id])
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

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user? @user
    end
end
