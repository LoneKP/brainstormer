class AddLikesToIdeas < ActiveRecord::Migration[6.0]
  def change
    add_column :ideas, :likes, :integer
  end
end
