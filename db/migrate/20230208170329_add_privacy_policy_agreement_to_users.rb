class AddPrivacyPolicyAgreementToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :privacy_policy_agreement, :boolean
  end
end
