class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions, {:id => false} do |t|
      t.string :id, :null => false
      t.references :user
      t.references :bet
      t.string :prediction, :default => ""
      t.boolean :result
      t.string :user_ack

      t.timestamps
    end
    
    add_index :predictions, :id, :unique => true
    add_index :predictions, :user_id
    add_index :predictions, :bet_id
  end
end
