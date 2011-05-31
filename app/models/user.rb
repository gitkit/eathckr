class User < ActiveRecord::Base  
  has_many :attendances
  has_many :meals, :through => :attendances
end
