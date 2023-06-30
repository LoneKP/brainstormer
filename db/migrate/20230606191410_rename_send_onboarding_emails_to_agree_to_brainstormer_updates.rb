class RenameSendOnboardingEmailsToAgreeToBrainstormerUpdates < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :send_onboarding_emails, :agree_to_brainstormer_updates
  end
end
