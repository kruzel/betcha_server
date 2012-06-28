class CreateUserBets < ActiveRecord::Migration
  def change
    create_table :user_bets do |t|
      t.references :user
      t.references :bet
      t.string :user_result_bet
      t.datetime :date
      t.boolean :result
      t.string :user_ack

      t.timestamps
    end
    
    add_index :user_bets, :user_id
    add_index :user_bets, :bet_id
  end
end
