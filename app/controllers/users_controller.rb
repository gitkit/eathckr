class UsersController < ApplicationController
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :find_user, :only => [:edit, :update, :show]
  
  def user_status
    render :json => {
      :registered => !!User.find_by_email(params[:email]),
      :legacy => true
    }
  end
  
  def new  
    @user = User.new
    @submit_text = "Let's get started"
  end  

  def create  
    @user = User.new(params[:user])  
    if @user.save  
      flash[:win] = "Registration successful. Welcome to eathckr!"  
      redirect_to root_url  
    else  
      flash.now[:fail] = "Ah, we couldn't register you. Try again please."
      render :action => :new  
    end  
  end
  
  def edit
    if @user != current_user
      flash[:fail] = "You can't edit someone else's profile!"
      redirect_back_or_default(root_url)
    end
    @submit_text = "Update your profile"
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:win] = "You've succesfully updated your profile."
      redirect_to edit_user_url(@user)
    else
      flash.now[:fail] = "There was an error saving your profile."
      render :edit
    end
  end
  
  def show
  end
    
  private
  
    def find_user
      @user = User.find(params[:id])
    end

end
