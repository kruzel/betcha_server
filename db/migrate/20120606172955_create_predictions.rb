class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions, {:id => false} do |t|
      t.string :id, :null => false
      t.string :user_id, :references => :users
      t.string :bet_id, :references => :bets
      t.string :prediction, :default => ""
      t.boolean :result
      t.string :user_ack
      t.boolean :participating, :default => true
      t.boolean :archive, :default => false     #user marked as archived, do not return unless explicitly requested
      t.string :prediction_option_id, :references => :prediction_options

      t.timestamps
    end
    
    add_index :predictions, :id, :unique => true
    add_index :predictions, :user_id
    add_index :predictions, :bet_id
    add_index :predictions, :prediction_option_id
  end
end
