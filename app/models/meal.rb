class Meal < ActiveRecord::Base
  
  has_many :attendances, :dependent => :destroy
  has_many :users, :through => :attendances, :uniq => true
  
  validates_presence_of :name, :total_seats, :location, :cuisine, :message => "Please fill out this field."
  
  validates_numericality_of :min_guests, :only_integer => true, :greater_than => 0, :message => "This needs to be at least 1."
  
  validate :more_seats_than_min_guests
  validate :try_to_parse_time

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
  
  def guests_for_threshold
    self.min_guests - self.taken_seats
  end
  
  def guests_for_threshold_str
    g = self.guests_for_threshold
    return '1 more guest' if g == 1
    "#{g} more guests"
  end
  
  def guest_attendances
    self.attendances.reject{ |a| a.user == self.host}
  end
  
  private
  
    def try_to_parse_time
      begin
        self.time = DateTime.parse(self.time_str)
      rescue
        errors.add(:time_str, "Sorry, we couldn't interpret this time.")
      end
    end
    
    def more_seats_than_min_guests
      if self.total_seats && self.min_guests && self.total_seats < self.min_guests
        errors.add(:min_guests, "You need to have more available seats than the minumum number of guests!")
      end
    end
    
end
