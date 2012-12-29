class CreateBadgeTypes < ActiveRecord::Migration
  def change
    create_table :badge_types, {:id => false} do |t|
      t.string :id, :null => false
      t.string :name
      t.attachment :image

      t.timestamps
    end

    add_index :badge_types, :id, :unique => true
  end
end
