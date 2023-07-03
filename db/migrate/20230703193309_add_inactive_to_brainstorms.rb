class AddInactiveToBrainstorms < ActiveRecord::Migration[7.0]
  def change
    add_column :brainstorms, :inactive_at, :datetime, default: nil
  end
end
