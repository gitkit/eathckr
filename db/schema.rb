# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110601182809) do

  create_table "attendances", :force => true do |t|
    t.integer   "user_id"
    t.integer   "meal_id"
    t.string    "kind"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "num_attending", :default => 1
  end

  create_table "meals", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                       :null => false
    t.string   "cuisine",                    :null => false
    t.integer  "total_seats",                :null => false
    t.datetime "time",                       :null => false
    t.string   "location",                   :null => false
    t.text     "description"
    t.integer  "min_guests",  :default => 1
  end

  create_table "users", :force => true do |t|
    t.string    "name"
    t.string    "email"
    t.string    "crypted_password",  :null => false
    t.string    "password_salt",     :null => false
    t.string    "persistence_token", :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

end
