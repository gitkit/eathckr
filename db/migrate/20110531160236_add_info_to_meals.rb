class AddInfoToMeals < ActiveRecord::Migration
  def self.up
    add_column :meals, :name, :string
    add_column :meals, :cuisine, :string
    add_column :meals, :total_seats, :integer
    add_column :meals, :start_time, :datetime
    add_column :meals, :location, :string
    add_column :meals, :description, :string
  end

  def self.down
    remove_column :meals, :start_time
    remove_column :meals, :location
    remove_column :meals, :description
  end
end
