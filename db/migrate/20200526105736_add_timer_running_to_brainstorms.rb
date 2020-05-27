class AddTimerRunningToBrainstorms < ActiveRecord::Migration[6.0]
  def change
    add_column :brainstorms, :timer_running, :boolean, default: false
  end
end
