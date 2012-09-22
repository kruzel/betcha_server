class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends, {:id => false} do |t|
      t.string :id, :null => false
      t.references :user
      t.integer :friend_id

      t.timestamps
    end
    
    add_index :friends, :id, :unique => true
    add_index :friends, :user_id
    add_index :friends, :friend_id
  end
end
