class CreateStakes < ActiveRecord::Migration
  def change
    create_table :stakes, {:id => false} do |t|
      t.string :id, :null => false
      t.string :name
      t.attachment :image
      t.string :affiliate_token
      t.string :affiliate_url

      t.timestamps
    end

    add_index :stakes, :id, :unique => true
  end
end
