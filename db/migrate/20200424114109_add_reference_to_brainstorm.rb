class AddReferenceToBrainstorm < ActiveRecord::Migration[6.0]
  def change
    add_reference :brainstorms, :admin, foreign_key: true
  end
end
