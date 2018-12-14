#require 'byebug'
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :index, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new(params[:id])
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
    store_location
    Rails::logger.debug "stored location"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # log_in @user # not logging in because account not activated
      @user.send_activation_email
      flash[:info] = "Please check your email's inbox to activate your account."
      # redirect_to user_url(@user) #also only @user is enough # commented because account activation required after signing in
      redirect_to root_path
    else
      render 'new'
      Rails::logger.debug "#{@user.errors.full_messages}"
    end

  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    #byebug
  end

  def edit
    @user = User.find(params[:id])
    store_location
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User has been deleted."
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user? @user
        flash[:danger] = "Not a valid user for accessing target page."
        redirect_back_or root_path
      end
    end

    def admin_user
      unless current_user.admin?
        flash[:danger] = "Not an administrator."
        redirect_to root_path
      end
    end

end
