class ApplicationController < ActionController::Base

  protect_from_forgery

  layout 'application'
  
  helper_method :current_user, :current_user_session

  before_filter :set_xrds_header
    
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
      redirect_to login_url unless current_user
    end
  
    def require_no_user
      if current_user
        flash[:fail] = "Wait a sec--you're already logged in!"
        redirect_back_or_default(root_url)
      end
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def set_xrds_header
      response.headers['X-XRDS-Location'] = yadis_url(:format => 'xml')
    end

end
