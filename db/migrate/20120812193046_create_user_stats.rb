class CreateUserStats < ActiveRecord::Migration
  def change
    create_table :user_stats, {:id => false} do |t|
      t.string :id, :null => false
      t.references :user
      t.integer :wins, :default => 0
      t.integer :consecuitive_wins, :default => 0
      t.integer :same_reward_wins, :default => 0
      t.integer :invites, :default => 0
      t.integer :bet_creations, :default => 0
      t.integer :participations, :default => 0

      t.timestamps
    end
    
    add_index :user_stats, :id, :unique => true
    add_index :user_stats, :user_id
  end
end
