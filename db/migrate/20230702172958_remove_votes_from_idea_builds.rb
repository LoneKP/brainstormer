class RemoveVotesFromIdeaBuilds < ActiveRecord::Migration[7.0]
  def change
    remove_column :idea_builds, :votes, :integer, default: 0
  end
end
