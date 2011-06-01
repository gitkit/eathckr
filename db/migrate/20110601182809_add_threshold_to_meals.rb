class AddThresholdToMeals < ActiveRecord::Migration
  def self.up
    add_column :meals, :min_guests, :integer, :default => 1
    Meal.reset_column_information
  end

  def self.down
    remove_column :meals, :min_guests, :integer
  end
end
