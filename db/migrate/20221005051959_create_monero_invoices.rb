class CreateMoneroInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :monero_invoices do |t|
      t.references :buyer, foreign_key: {to_table: :users}
      t.references :recipient, foreign_key: {to_table: :users}
      t.references :monero_plan, foreign_key: true
      t.string :address
      t.string :address_qrcode
      t.string :amount
      t.string :display_amount
      t.string :payment_uri
      t.string :payment_uri_qrcode
      t.boolean :paid

      t.timestamps
    end
  end
end
