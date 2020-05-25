class AddTokenToBrainstorms < ActiveRecord::Migration[6.0]
  def change
    add_column :brainstorms, :token, :string
  end
end
