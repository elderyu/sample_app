require 'byebug'
class UsersController < ApplicationController
  def new
  end
  def show
    @user = User.find(params[:id])
    byebug
  end
end
