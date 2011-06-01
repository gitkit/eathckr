class Attendance < ActiveRecord::Base
  belongs_to :meal
  belongs_to :user
  
  before_create :check_if_host
  validate :not_too_many_guests
  
  TYPES = [:host, :invited, :guest]

  private
  
    def check_if_host
      if meal.attendances.length == 0 # If this is a meal's first attendance, we must have a host
        self.kind = 'host'
      end
    end
  
    def not_too_many_guests
      num_available = self.meal.available_seats
      if num_available < self.num_attending
        plural_str = (num_available == 1 ? "is only 1 seat" : "are only #{num_available} seats")
        errors.add(:base, "Sorry, there #{plural_str} remaining")
      end
    end
  
end
