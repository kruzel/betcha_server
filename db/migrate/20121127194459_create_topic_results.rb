class CreateTopicResults < ActiveRecord::Migration
  def change
    create_table :topic_results, {:id => false} do |t|
      t.string :id, :null => false
      t.string :topic_id, :references => :topics
      t.string :prediction_option_id, :references => :prediction_options
      t.integer :score1
      t.integer :score2

      t.timestamps
    end

    add_index :topic_results, :id, :unique => true
    add_index :topic_results, :topic_id
    add_index :topic_results, :prediction_option_id
  end
end
