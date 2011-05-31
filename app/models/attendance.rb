class Attendance < ActiveRecord::Base
  belongs_to :meal
  belongs_to :user
  
  TYPES = [:host, :invited, :guest]
end
