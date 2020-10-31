class CreateIdeaBuilds < ActiveRecord::Migration[6.0]
  def change
    create_table :idea_builds do |t|
      t.string :text
      t.belongs_to :idea

      t.timestamps
    end
  end
end
