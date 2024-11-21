class DropCategories < ActiveRecord::Migration[7.0]
  def change
    drop_table :categories
  end
end
