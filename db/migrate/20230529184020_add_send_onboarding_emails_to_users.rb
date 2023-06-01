class AddSendOnboardingEmailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :send_onboarding_emails, :boolean, default: true
  end
end
