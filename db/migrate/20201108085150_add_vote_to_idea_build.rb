class AddVoteToIdeaBuild < ActiveRecord::Migration[6.0]
  def change
    add_column :idea_builds, :votes, :integer, default: 0
  end
end
