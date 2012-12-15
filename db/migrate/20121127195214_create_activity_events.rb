class CreateActivityEvents < ActiveRecord::Migration
  def change
    create_table :activity_events, {:id => false} do |t|
      t.string :id, :null => false
      t.string :event_type
      t.string :object_id
      t.string :description

      t.timestamps
    end

    add_index :activity_events, :id, :unique => true
  end
end
