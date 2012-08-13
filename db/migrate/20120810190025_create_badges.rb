class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.references :user
      t.string :type

      t.timestamps
    end
    add_index :badges, :user_id
  end
end
