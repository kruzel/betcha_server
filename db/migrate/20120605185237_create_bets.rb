class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
#      t.string :uuid
      t.references :user
      t.string :subject
      t.string :reward
      t.datetime :due_date
      t.string :state

      t.timestamps
    end
    
    add_index :bets, :user_id
#    add_index :bets, :uuid
  end
end
