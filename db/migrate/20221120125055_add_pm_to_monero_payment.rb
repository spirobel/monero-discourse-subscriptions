class AddPmToMoneroPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :monero_payments, :pm, :boolean
  end
end
