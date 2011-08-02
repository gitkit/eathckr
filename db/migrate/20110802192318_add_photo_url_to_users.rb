class AddPhotoUrlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :photo_url, :string
  end

  def self.down
    remove_column :photo_url, :users
  end
end
