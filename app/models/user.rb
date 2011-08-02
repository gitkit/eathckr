class User < ActiveRecord::Base 
  
  acts_as_authentic
  # acts_as_federated
  
  has_many :attendances, :dependent => :destroy
  has_many :meals, :through => :attendances, :uniq => true, :dependent => :destroy
  
  def user_data
    {
      :displayName => self.name,
      :email => self.email,
      :legacy => true,
      :photoUrl => self.photo_url
    }
  end
  
  def self.new_federated(assertion)
    name = begin
      assertion["firstName"] + " " + assertion["lastName"]
    rescue
      assertion["fullName"] || assertion["nickName"]
    end
    User.new(:email => assertion["verifiedEmail"] || assertion["email"],
             :name => name,
             :photo_url => assertion["profilePicture"],
             :password => FEDERATED_PASSWORD,
             :password_confirmation => FEDERATED_PASSWORD)
  end
  
  def federated?
    self.valid_password?(FEDERATED_PASSWORD)
  end
  
  def upgrade
    unless self.federated?
      self.password = FEDERATED_PASSWORD
      self.password_confirmation = FEDERATED_PASSWORD
    end
    self.save
  end
    
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
