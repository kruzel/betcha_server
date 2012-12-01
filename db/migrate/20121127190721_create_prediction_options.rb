class CreatePredictionOptions < ActiveRecord::Migration
  def change
    create_table :prediction_options, {:id => false} do |t|
      t.string :id, :null => false
      t.string :name
      t.attachment :image
      t.string :topic_id, :references => :topics

      t.timestamps
    end

    add_index :prediction_options, :id, :unique => true
  end
end
