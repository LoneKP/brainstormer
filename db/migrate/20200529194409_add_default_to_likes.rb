class AddDefaultToLikes < ActiveRecord::Migration[6.0]
  def up
    change_column :ideas, :likes, :integer, default: 0
  end

  def down
    change_column :ideas, :likes, :integer
  end
end
