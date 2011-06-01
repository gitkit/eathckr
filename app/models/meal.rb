class Meal < ActiveRecord::Base
  
  has_many :attendances, :dependent => :destroy
  has_many :users, :through => :attendances, :uniq => true
  
  # before_save :parse_time
  validate :more_seats_than_min_guests
  validate :parse_time
  validates_presence_of :name, :total_seats, :location, :time, :cuisine, :message => "You have to fill this out!"
  
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
      begin
        self.time = DateTime.parse(self.time_str)
      rescue
        errors.add(:time_str, "Sorry, we couldn't interpret this time.")
      end
    end
    
    def more_seats_than_min_guests
      if self.total_seats && self.total_seats < self.min_guests
        errors.add(:min_guests, "You need to have more available seats than the minumum number of guests!")
      end
    end
    
end
