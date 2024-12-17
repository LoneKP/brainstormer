class UpgradeToPay7 < ActiveRecord::Migration[7.2]
  def change
    add_column :pay_subscriptions, :payment_method_id, :string
    add_column :pay_customers, :stripe_account, :string
    add_column :pay_subscriptions, :stripe_account, :string
    add_column :pay_payment_methods, :stripe_account, :string
    add_column :pay_charges, :stripe_account, :string
  end
end
