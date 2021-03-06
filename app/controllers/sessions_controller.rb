class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase) #downcase to ensure
    if @user && @user.authenticate(params[:session][:password])     # previously: if user && user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or user_path(@user) # user == user_url(user)
      else
        message = "Account not activated."
        message += "Check your email for the activtion link."
        flash[:danger] = message
        redirect_to root_path
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    forget_location
    redirect_to root_path
  end

end
