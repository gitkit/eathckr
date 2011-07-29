class MealsController < ApplicationController

  before_filter :require_user
  before_filter :find_meal, :only => [:edit, :update, :show, :destroy, :attend, :update_attendance]

  def index
    @user = current_user
  end
  
  def show
    @user = current_user
    @attendance = @meal.attendances.find_by_user_id(@user) || 
      Attendance.new(:user_id => @user, :meal_id => @meal)
  end
  
  def new
    @meal = Meal.new
  end
  
  def create
    @user = current_user
    @meal = @user.meals.build(params[:meal])  
    if @user.save
      flash[:win] = "Yay! Here's the meal you're hosting."
      redirect_to @meal
    else
      flash.now[:fail] = "Whoops--there's a problem saving your meal."
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @meal.update_attributes(params[:meal])
      flash[:win] = "Yay! Here's the meal you're hosting."
      redirect_to @meal
    else
      flash.now[:fail] = "Whoops--there's a problem saving your meal."
      render :edit
    end
  end
  
  def attend
    @user = current_user
    if update_attendance
      redirect_to @meal
    else
      flash.now[:fail] = "Whoops--we couldn't save your reservation. Please try again."
      render :show
    end
  end
  
  def destroy
  end
  
  private
  
    def find_meal
      @meal = Meal.find(params[:id])
    end
    
    def update_attendance
      if @attendance = @meal.attendances.find_by_user_id(@user)
        @attendance.destroy
        flash[:win] = "Your reservation has been cancelled."
      else
        @attendance = @user.attendances.build(:meal_id => @meal.id, 
                                              :kind => 'guest', 
                                              :num_attending => params[:num_attending])
        @attendance.save
        flash[:win] = "Your reservation has been saved."
      end
    end
  
end
