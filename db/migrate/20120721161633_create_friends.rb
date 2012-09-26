class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends, {:id => false} do |t|
      t.string :id, :null => false
      t.string :user_id, :references => :users
      t.string :friend_id, :references => :users

      t.timestamps
    end
    
    add_index :friends, :id, :unique => true
    add_index :friends, :user_id
    add_index :friends, :friend_id
  end
end
