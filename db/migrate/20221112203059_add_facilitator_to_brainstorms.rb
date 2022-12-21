class AddFacilitatorToBrainstorms < ActiveRecord::Migration[6.1]
  def change
    add_reference :brainstorms, :facilitated_by, polymorphic: true
  end
end