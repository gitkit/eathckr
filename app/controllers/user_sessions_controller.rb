class UserSessionsController < ApplicationController
  
  before_filter :require_no_user, :only => [:new, :create]
  
  def new
    @user_session = UserSession.new 
  end
  
  def create  
    @user_session = UserSession.new(params[:user_session])  
    if @user_session.save  
      flash[:win] = "Welcome back!"  
      redirect_to root_url  
    else  
      flash[:fail] = "Sorry, we couldn't log you in--try again!"
      render :action => :new
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
  
end
