class CreateActivityEventUsers < ActiveRecord::Migration
  def change
    create_table :activity_event_users do |t|
      t.string :id, :null => false
      t.string :activity_event_id, :references => :activity_events
      t.string :user_id, :references => :users

      t.timestamps
    end

    add_index :activity_event_users, :id, :unique => true
    add_index :activity_event_users, :activity_event_id
    add_index :activity_event_users, :user_id
  end
end
