class ChangeTextToIdeaBuildTextInIdeaBuilds < ActiveRecord::Migration[6.0]
  def change
    rename_column :idea_builds, :text, :idea_build_text
  end
end
