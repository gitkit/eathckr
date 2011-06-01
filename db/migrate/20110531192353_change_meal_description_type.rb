class ChangeMealDescriptionType < ActiveRecord::Migration
  def self.up
    change_column :meals, :description, :text
  end

  def self.down
    change_column :meals, :description, :string
  end
end
