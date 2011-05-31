class ApplicationController < ActionController::Base

  protect_from_forgery

  layout 'application'
  
  helper_method :current_user, :current_user_session

  private  
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def require_user
    redirect_to signup_url unless current_user
  end
  
  def require_no_user
    if current_user
      flash[:fail] = "Why would you want to do that? You're already logged in!"
      redirect_back_or_default(root_url)
    end
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
