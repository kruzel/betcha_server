class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages, {:id => false} do |t|
      t.string :id, :null => false
      t.references :bet
      t.references :user
      t.integer :type
      t.string :message
      t.boolean :notification_sent

      t.timestamps
    end
    
    add_index :chat_messages, :id, :unique => true
    add_index :chat_messages, :bet_id
    add_index :chat_messages, :user_id
  end
end
