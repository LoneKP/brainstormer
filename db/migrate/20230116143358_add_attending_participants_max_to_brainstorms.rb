class AddAttendingParticipantsMaxToBrainstorms < ActiveRecord::Migration[7.0]
  def change
    add_column :brainstorms, :max_participants, :integer, default: 0
  end
end
