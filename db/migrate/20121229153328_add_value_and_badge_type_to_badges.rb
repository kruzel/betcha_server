class AddValueAndBadgeTypeToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :value, :integer
    add_column :badges, :badge_type_id, :string, :references => :badge_types, :null => false
  end
end
