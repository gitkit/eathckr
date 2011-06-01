class ChangeNameOfAttendanceType < ActiveRecord::Migration
  def self.up
    rename_column :attendances, :type, :kind
  end

  def self.down
    rename_column :attendances, :kind, :type
  end
end
