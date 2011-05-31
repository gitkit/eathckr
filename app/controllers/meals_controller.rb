class MealsController < ApplicationController

  before_filter :require_user

  def index
    @meals = Meal.all
  end
  
  def new
  end
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
end
