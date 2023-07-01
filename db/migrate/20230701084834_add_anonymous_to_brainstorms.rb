class AddAnonymousToBrainstorms < ActiveRecord::Migration[7.0]
  def change
    add_column :brainstorms, :anonymous, :boolean, default: true
  end
end
