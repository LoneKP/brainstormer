class DropBrainstormsCategories < ActiveRecord::Migration[7.0]
  def change
    drop_table :brainstorms_categories
  end
end
