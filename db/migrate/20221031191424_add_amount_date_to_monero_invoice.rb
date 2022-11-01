class AddAmountDateToMoneroInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :monero_invoices, :amount_date, :datetime
    add_column :monero_invoices, :missing_amount, :string
    add_column :monero_invoices, :missing_currency, :string
  end
end
