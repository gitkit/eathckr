class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.integer :user_id, :null => :false
      t.integer :meal_id, :null => :false
      t.string :type, :null => :false
      t.timestamps
    end
  end

  def self.down
    drop_table :attendances
  end
end
