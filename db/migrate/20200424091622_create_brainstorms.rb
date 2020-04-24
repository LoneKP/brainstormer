class CreateBrainstorms < ActiveRecord::Migration[6.0]
  def change
    create_table :brainstorms do |t|
      t.text :problem

      t.timestamps
    end
  end
end
