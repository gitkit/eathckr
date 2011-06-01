class User < ActiveRecord::Base 
  
  acts_as_authentic
  
  has_many :attendances, :dependent => :destroy
  has_many :meals, :through => :attendances, :uniq => true
  
  def potential_meals
    Meal.all - self.meals
  end
  
  def hosted_meals
    self.attendances.where(:kind => 'host').map(&:meal)
  end
  
  def attended_meals
    self.attendances.where(:kind => 'guest').map(&:meal)
  end
  
  def attending_meals
    self.attended_meals.select{ |m| m.time > Time.now}
  end

end
