class Meal < ActiveRecord::Base
  
  has_many :attendances, :dependent => :destroy
  has_many :users, :through => :attendances, :uniq => true
  
  before_save :parse_time
  
  attr_accessor :time_str

  def host
    self.attendances.where(:kind => 'host').first.user
  end
  
  def taken_seats
    return 0 if self.attendances.blank?
    self.attendances.map(&:num_attending).reduce(:+) - 1 # Minus one for the host
  end
  
  def available_seats
    self.total_seats - self.taken_seats
  end
  
  def available_seats_str
    s = self.available_seats
    return '1 seat' if s == 1
    "#{s} seats"
  end
  
  def guest_attendances
    self.attendances.reject{ |a| a.user == self.host}
  end
  
  private
  
    def parse_time
      self.time = DateTime.parse(self.time_str)
    end
    
end
