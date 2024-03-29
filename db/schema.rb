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

ActiveRecord::Schema.define(:version => 20121229151518) do

  create_table "activity_event_users", :force => true do |t|
    t.string   "activity_event_id"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_event_users", ["activity_event_id"], :name => "index_activity_event_users_on_activity_event_id"
  add_index "activity_event_users", ["id"], :name => "index_activity_event_users_on_id", :unique => true
  add_index "activity_event_users", ["user_id"], :name => "index_activity_event_users_on_user_id"

  create_table "activity_events", :force => true do |t|
    t.string   "event_type"
    t.string   "obj_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_events", ["id"], :name => "index_activity_events_on_id", :unique => true

  create_table "badge_types", :force => true do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "badge_types", ["id"], :name => "index_badge_types_on_id", :unique => true

  create_table "badges", :force => true do |t|
    t.string   "user_id"
    t.integer  "value"
    t.string   "badge_type_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "badges", ["id"], :name => "index_badges_on_id", :unique => true
  add_index "badges", ["user_id"], :name => "index_badges_on_user_id"

  create_table "bets", :force => true do |t|
    t.string   "user_id"
    t.string   "subject"
    t.string   "reward"
    t.string   "stake_id"
    t.datetime "due_date"
    t.string   "state"
    t.string   "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "topic_category_id"
  end

  add_index "bets", ["id"], :name => "index_bets_on_id", :unique => true
  add_index "bets", ["topic_id"], :name => "index_bets_on_topic_id"
  add_index "bets", ["user_id"], :name => "index_bets_on_user_id"

  create_table "chat_messages", :force => true do |t|
    t.string   "bet_id"
    t.string   "user_id"
    t.integer  "type"
    t.string   "message"
    t.boolean  "notification_sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chat_messages", ["bet_id"], :name => "index_chat_messages_on_bet_id"
  add_index "chat_messages", ["id"], :name => "index_chat_messages_on_id", :unique => true
  add_index "chat_messages", ["user_id"], :name => "index_chat_messages_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "friends", :force => true do |t|
    t.string   "user_id"
    t.string   "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friends", ["friend_id"], :name => "index_friends_on_friend_id"
  add_index "friends", ["id"], :name => "index_friends_on_id", :unique => true
  add_index "friends", ["user_id"], :name => "index_friends_on_user_id"

  create_table "gcm_devices", :force => true do |t|
    t.string   "registration_id",    :null => false
    t.datetime "last_registered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gcm_devices", ["registration_id"], :name => "index_gcm_devices_on_registration_id", :unique => true

  create_table "gcm_notifications", :force => true do |t|
    t.integer  "device_id",        :null => false
    t.string   "collapse_key"
    t.text     "data"
    t.boolean  "delay_while_idle"
    t.datetime "sent_at"
    t.integer  "time_to_live"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gcm_notifications", ["device_id"], :name => "index_gcm_notifications_on_device_id"

  create_table "locations", :force => true do |t|
    t.string   "country"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["id"], :name => "index_locations_on_id", :unique => true

  create_table "prediction_options", :force => true do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prediction_options", ["id"], :name => "index_prediction_options_on_id", :unique => true

  create_table "predictions", :force => true do |t|
    t.string   "user_id"
    t.string   "bet_id"
    t.string   "prediction",           :default => ""
    t.boolean  "result"
    t.string   "user_ack"
    t.boolean  "participating",        :default => true
    t.boolean  "archive",              :default => false
    t.string   "prediction_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "predictions", ["bet_id"], :name => "index_predictions_on_bet_id"
  add_index "predictions", ["id"], :name => "index_predictions_on_id", :unique => true
  add_index "predictions", ["prediction_option_id"], :name => "index_predictions_on_prediction_option_id"
  add_index "predictions", ["user_id"], :name => "index_predictions_on_user_id"

  create_table "stakes", :force => true do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "affiliate_token"
    t.string   "affiliate_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stakes", ["id"], :name => "index_stakes_on_id", :unique => true

  create_table "topic_categories", :force => true do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topic_categories", ["id"], :name => "index_topic_categories_on_id", :unique => true

  create_table "topic_results", :force => true do |t|
    t.string   "topic_id"
    t.string   "prediction_option_id"
    t.integer  "score1"
    t.integer  "score2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topic_results", ["id"], :name => "index_topic_results_on_id", :unique => true
  add_index "topic_results", ["prediction_option_id"], :name => "index_topic_results_on_prediction_option_id"
  add_index "topic_results", ["topic_id"], :name => "index_topic_results_on_topic_id"

  create_table "topics", :force => true do |t|
    t.string   "topic_category_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "location_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topics", ["id"], :name => "index_topics_on_id", :unique => true
  add_index "topics", ["location_id"], :name => "index_topics_on_location_id"
  add_index "topics", ["topic_category_id"], :name => "index_topics_on_topic_category_id"

  create_table "user_stats", :force => true do |t|
    t.string   "user_id"
    t.integer  "wins",              :default => 0
    t.integer  "consecuitive_wins", :default => 0
    t.integer  "same_reward_wins",  :default => 0
    t.integer  "invites",           :default => 0
    t.integer  "bet_creations",     :default => 0
    t.integer  "participations",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_stats", ["id"], :name => "index_user_stats_on_id", :unique => true
  add_index "user_stats", ["user_id"], :name => "index_user_stats_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                        :default => "", :null => false
    t.string   "encrypted_password",           :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "first_name"
    t.string   "family_name"
    t.string   "full_name"
    t.boolean  "is_app_installed"
    t.string   "push_notifications_device_id"
    t.string   "device_type"
    t.string   "gender"
    t.string   "locale"
    t.string   "profile_pic_url"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.datetime "expires_at"
    t.boolean  "expires"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "coins"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id"], :name => "index_users_on_id", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
