class RemovePublicFromBrainstorms < ActiveRecord::Migration[7.0]
  def change
    remove_column :brainstorms, :public, :boolean, default: false
  end
end
