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

ActiveRecord::Schema.define(:version => 20120724192844) do

  create_table "bets", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.string   "reward"
    t.datetime "due_date"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bets", ["user_id"], :name => "index_bets_on_user_id"

  create_table "chat_messages", :force => true do |t|
    t.integer  "bet_id"
    t.integer  "user_id"
    t.integer  "type"
    t.string   "message"
    t.boolean  "notification_sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chat_messages", ["bet_id"], :name => "index_chat_messages_on_bet_id"
  add_index "chat_messages", ["user_id"], :name => "index_chat_messages_on_user_id"

  create_table "friends", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends", ["friend_id"], :name => "index_friends_on_friend_id"
  add_index "friends", ["user_id"], :name => "index_friends_on_user_id"

  create_table "predictions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bet_id"
    t.string   "prediction"
    t.boolean  "result"
    t.string   "user_ack"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "predictions", ["bet_id"], :name => "index_predictions_on_bet_id"
  add_index "predictions", ["user_id"], :name => "index_predictions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "first_name"
    t.string   "family_name"
    t.string   "full_name"
    t.boolean  "is_app_installed"
    t.integer  "gender"
    t.string   "locale"
    t.string   "profile_pic_url"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.datetime "expires_at"
    t.boolean  "expires"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
