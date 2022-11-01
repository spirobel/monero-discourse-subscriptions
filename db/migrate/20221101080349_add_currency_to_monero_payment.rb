class AddCurrencyToMoneroPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :monero_payments, :currency, :string
    add_column :monero_payments, :arrival_amount, :string
  end
end
