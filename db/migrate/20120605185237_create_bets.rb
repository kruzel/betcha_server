class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets, {:id => false} do |t|
      t.string :id, :null => false
      t.string :user_id, :references => :users
      t.string :subject
      t.string :reward  #custom stake
      t.string :stake_id, :references => :stakes    #define either reward of stake from list
      t.datetime :due_date
      t.string :state
      t.string :topic_id, :references => :topics

      t.timestamps
    end
    
    add_index :bets, :id, :unique => true
    add_index :bets, :user_id
    add_index :bets, :topic_id
  end
end
