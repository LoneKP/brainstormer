class ChangeLikesToVotes < ActiveRecord::Migration[6.0]
  def change
    rename_column :ideas, :likes, :votes
  end
end
