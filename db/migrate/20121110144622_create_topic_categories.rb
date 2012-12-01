class CreateTopicCategories < ActiveRecord::Migration
  def change
    create_table :topic_categories, {:id => false} do |t|
      t.string :id, :null => false
      t.string :name
      t.attachment :image

      t.timestamps
    end

    add_index :topic_categories, :id, :unique => true
  end
end
