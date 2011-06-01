class MealsController < ApplicationController

  before_filter :require_user
  before_filter :find_meal, :only => [:edit, :update, :show]

  def index
    @user = current_user
  end
  
  def show
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
  
  def destroy
  end
  
  private
  
    def find_meal
      @meal = Meal.find(params[:id])
    end
  
end
