class CreateTopicCategories < ActiveRecord::Migration
  def change
    create_table :topic_categories do |t|
      t.string :id
      t.string :name
      t.attachment :image

      t.timestamps
    end
  end
end
