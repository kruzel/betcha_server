class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations, {:id => false} do |t|
      t.string :id, :null => false
      t.string :country
      t.string :city

      t.timestamps
    end

    add_index :locations, :id, :unique => true
  end
end
