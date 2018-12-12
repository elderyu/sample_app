class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by email: params[:email] # cant find by id because id is an activation token
    if user && !user.activated? && user.authenticated?(:activation, params[:id])  # because activation token is in id
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation token"
      redirect_to root_path
    end
  end

end
