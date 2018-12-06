module SessionsHelper

  def log_in user
    session[:user_id] = user.id # other than session controller
  end

  def log_out
    session.delete :user_id
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?   #@current_user.nil? ? true : false
  end

  def session_started
    !session[:user_id].nil?
  end

end
