class UserSessionsController < ApplicationController
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy]
  
  def new
  end
      
  def create  
    if params[:password].blank?
      render :json => {
        :registered => !!User.find_by_email(params[:email]),
        :legacy => false
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
    
    api_url = "https://www.googleapis.com/identitytoolkit/v1/relyingparty/verifyAssertion?key=#{GITKIT_DEVKEY}"
    
    begin
      api_response = RestClient.post(api_url, api_params.to_json, :content_type => :json )
    
      verified_assertion = JSON.parse(api_response)
      # render :text => verified_assertion.inspect
      
    rescue RestClient::BadRequest => error
      # error = JSON.parse(e)
      render :text => error.inspect
    end
    
    verified_email = verified_assertion["verifiedEmail"]
    
    if true # status == 'success'!!
      if @user = User.find_by_email(verified_email)
        @user.upgrade
      else
        @user = User.new(:email => verified_email, :name => verified_assertion["firstName"] + " " + verified_assertion["lastName"],
                         :password => FEDERATED_PASSWORD, :password_confirmation => FEDERATED_PASSWORD)
      end
    end
    
    if @user.save
      @user_session = UserSession.create(:email => verified_email, :password => FEDERATED_PASSWORD)
      @status = "success"
    else
      @status = "invalidAssertion" 
    end
    
    logger.info("\n\n#{verified_assertion.inspect}\n\n")
    
    render 'javascript_redirect', :layout => false
    
  end
  
  def user_status
  end
  
  
end
