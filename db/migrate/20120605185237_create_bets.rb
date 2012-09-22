class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets, {:id => false} do |t|
      t.string :id, :null => false
      t.references :user
      t.string :subject
      t.string :reward
      t.datetime :due_date
      t.string :state

      t.timestamps
    end
    
    add_index :bets, :id, :unique => true
    add_index :bets, :user_id
#    add_index :bets, :uuid
  end
end
