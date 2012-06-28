# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120606172955) do

  create_table "bets", :force => true do |t|
    t.string   "uuid"
    t.integer  "user_id"
    t.string   "subject"
    t.string   "reward"
    t.datetime "date"
    t.datetime "due_date"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bets", ["user_id"], :name => "index_bets_on_user_id"
  add_index "bets", ["uuid"], :name => "index_bets_on_uuid"

  create_table "user_bets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bet_id"
    t.string   "user_result_bet"
    t.datetime "date"
    t.boolean  "result"
    t.string   "user_ack"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_bets", ["bet_id"], :name => "index_user_bets_on_bet_id"
  add_index "user_bets", ["user_id"], :name => "index_user_bets_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
