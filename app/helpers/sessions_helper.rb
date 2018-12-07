module SessionsHelper

  def log_in user
    session[:user_id] = user.id # other than session controller
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def remember user
    user.remember                                                 # calls remmeber function from User model
    cookies.permanent.signed[:user_id] = user.id                  # permanent = 20.years.from_now.utc, signed != encrypted, signed = not editable
    cookies.permanent[:remember_token] = user.remember_token
    cookies.signed[:user_id]
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    elsif user_id = cookies.signed[:user_id]
      #raise
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    else
      # crititcal fail
    end
  end

  def logged_in?
    !current_user.nil?   #@current_user.nil? ? true : false
  end

  def session_started
    !session[:user_id].nil?
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

end
