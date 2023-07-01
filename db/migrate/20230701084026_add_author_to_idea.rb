class AddAuthorToIdea < ActiveRecord::Migration[7.0]
  def change
    add_column :ideas, :author, :string
  end
end
