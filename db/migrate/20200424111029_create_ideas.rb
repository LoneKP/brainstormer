class CreateIdeas < ActiveRecord::Migration[6.0]
  def change
    create_table :ideas do |t|
      t.string :text
      t.belongs_to :brainstorm

      t.timestamps
    end
  end
end
