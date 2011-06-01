class FixMealDetails < ActiveRecord::Migration
  def self.up
    rename_column :meals, :start_time, :time
    change_column :meals, :time, :datetime, :null => false
    change_column :meals, :name, :string, :null => false
    change_column :meals, :cuisine, :string, :null => false
    change_column :meals, :total_seats, :integer, :null => false
    change_column :meals, :location, :string, :null => false
  end

  def self.down
    rename_column :meals, :time, :start_time
    change_column :meals, :time, :datetime, :null => true
    change_column :meals, :name, :string, :null => true
    change_column :meals, :cuisine, :string, :null => true
    change_column :meals, :total_seats, :integer, :null => true
    change_column :meals, :location, :string, :null => true
  end
end
