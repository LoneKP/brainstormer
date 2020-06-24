class RemoveTimerRunningFromBrainstorms < ActiveRecord::Migration[6.0]
  def change
    remove_column :brainstorms, :timer_running, :boolean
  end
end
