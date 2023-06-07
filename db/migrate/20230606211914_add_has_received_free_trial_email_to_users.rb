class AddHasReceivedFreeTrialEmailToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :has_received_free_trial_email, :boolean, default: false
  end
end
