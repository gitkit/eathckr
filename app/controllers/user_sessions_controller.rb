class UserSessionsController < ApplicationController
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy]
  
  def new
  end
      
  def create  
    if params[:password].blank?
      render :json => {
        :registered => !!User.find_by_email(params[:email]),
        # :legacy => false
      }
    else
      response = {}
      @user_session = UserSession.new(:email => params[:email], :password => params[:password])
      if @user_session.save
        @user = User.find_by_email(params[:email])
        response = {
          :status => "ok",
          :displayName => @user.name,
          :email => @user.email,
          :photoUrl => ''
        }
      else
        response = {
          :status => "passwordError"
        }
      end
      render :json => response
    end
  end  
  
  def destroy  
    if current_user_session.destroy  
      flash[:win] = "Successfully logged out. Thanks for visiting!"  
    else
      flash[:fail] = "You might not be logged out? Try again."
    end
    redirect_to root_url
  end  
  
  def openid_callback
    # Handle response from IDP

    api_params = {
      'requestUri' => request.url,
      'postBody' => request.post? ? request.raw_post : URI.parse(request.url).query
    }
    
    api_url = "https://www.googleapis.com/identitytoolkit/v1/relyingparty/" +
              "verifyAssertion?key=#{GITKIT_DEVKEY}"
    
    begin
      api_response = RestClient.post(api_url, api_params.to_json, :content_type => :json )
      verified_assertion = JSON.parse(api_response)
      verified_email = verified_assertion["verifiedEmail"]
      raise InvalidAssertion unless verified_email
    rescue RestClient::BadRequest => error
      logger.info "\n\n#{ error.inspect }\n\n"
      logger.info "\n\n#{ api_params.inspect }\n\n"
      @status = "error"
    rescue InvalidAssertion
      @status = "invalidAssertion"      
    else
      @user = User.find_by_email(verified_email) || User.new_federated(verified_assertion)
      if @user.upgrade && UserSession.create_federated(verified_email)
        @status = "success" 
      else
        @status = "failure"
      end
    ensure 
      render 'javascript_redirect', :layout => false
    end
        
  end
  
  def user_status
  end
  
  
end
