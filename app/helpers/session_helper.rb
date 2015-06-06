module SessionHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def Log_out
    remove_session_token(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remove_session_token(user)
    user.remove_session_token
    cookies.delete(:user_id)
    cookies.delete(:remembered_session_token)
  end

  def store_session_token(user)
    user.store_session_token
    cookie.permanent.signed[:user_id] = user.id
    cookie.permanent[:remembered_session_token] = user.session_token
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user

    if session[:user_id]

      @current_user ||= User.find(session[:user_id])

    elsif cookie.signed[:user_id]

      user = User.find(cookie.signed[:user_id])

      if user && user.authenticated?(cookies[:remembered_session_token])

        log_in user
        @current_user = user
      end
    end

  end

end
