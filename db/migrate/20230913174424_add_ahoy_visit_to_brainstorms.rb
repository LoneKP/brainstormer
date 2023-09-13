class AddAhoyVisitToBrainstorms < ActiveRecord::Migration[7.0]
  def change
    add_reference :brainstorms, :ahoy_visit
  end
end
