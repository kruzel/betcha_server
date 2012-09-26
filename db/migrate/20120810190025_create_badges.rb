class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges, {:id => false} do |t|
      t.string :id, :null => false
      t.string :user_id, :references => :users
      t.string :type

      t.timestamps
    end
    
    add_index :badges, :id, :unique => true
    add_index :badges, :user_id
  end
end
