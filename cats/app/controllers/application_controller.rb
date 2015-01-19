class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def login!(user)
    @current_user = user
    token = @current_user.sessions.last
    session[:session_token] = token.session_token
  end

  def logout!
    @session = Session.find_by_session_token(session[:session_token])
    @session.destroy
    session[:session_token] = nil
  end

  def require_current_user!
    redirect_to new_session_url if current_user.nil?
  end

  def current_user
    return nil if session[:session_token].nil?
    token = Session.find_by_session_token(session[:session_token])
    @current_user ||= User.find(token.user_id)
  end

  def redirect_if_logged_in
    redirect_to home_url unless current_user.nil?
  end

  def redirect_unless_logged_in
    redirect_to new_session_url if current_user.nil?
  end

end
