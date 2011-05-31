class User < ActiveRecord::Base 
  
  acts_as_authentic
  
  has_many :attendances
  has_many :meals, :through => :attendances
  
  def hosted_meals
    self.attendances(:where => {:type => :host})
  end
  
  def attended_meals
    self.attendances(:where => {:type => :guest})
  end

end
