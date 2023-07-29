class CreateJoinTableBrainstormCategories < ActiveRecord::Migration[7.0]
  def change
    create_join_table :brainstorms, :categories do |t|
      t.index [:brainstorm_id, :category_id], unique: true
      t.index [:category_id, :brainstorm_id], unique: true
    end
  end
end
