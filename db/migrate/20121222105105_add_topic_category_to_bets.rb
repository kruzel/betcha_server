class AddTopicCategoryToBets < ActiveRecord::Migration
  def change
    add_column :bets, :topic_category_id, :string, :references => :topic_categories
  end
end
