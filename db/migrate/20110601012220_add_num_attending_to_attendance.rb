class AddNumAttendingToAttendance < ActiveRecord::Migration
  def self.up
    add_column :attendances, :num_attending, :integer, :default => 1
  end

  def self.down
    remove_column :attendances, :num_attending
  end
end
