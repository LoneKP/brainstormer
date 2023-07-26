class AddPublicToBrainstorms < ActiveRecord::Migration[7.0]
  def change
    add_column :brainstorms, :public, :boolean, default: false
  end
end
