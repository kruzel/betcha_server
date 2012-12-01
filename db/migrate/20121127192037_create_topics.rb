class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics, {:id => false} do |t|
      t.string :id, :null => false
      t.string :topic_category_id, :references => :topic_categories
      t.datetime :start_time
      t.datetime :end_time
      t.string :location_id, :references => :locations
      t.string :name

      t.timestamps
    end

    add_index :topics, :id, :unique => true
    add_index :topics, :topic_category_id
    add_index :topics, :location_id
  end
end
