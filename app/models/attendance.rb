class Attendance < ActiveRecord::Base
  belongs_to :meal
  belongs_to :user
  
  before_create :check_if_host
  
  TYPES = [:host, :invited, :guest]
  
  def check_if_host
    if meal.attendances.length == 0 # If this is a meal's first attendance, we must have a host
      self.kind = 'host'
    end
  end
  
end
