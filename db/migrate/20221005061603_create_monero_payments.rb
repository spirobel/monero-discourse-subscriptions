class CreateMoneroPayments < ActiveRecord::Migration[7.0]
  def change
    create_table :monero_payments do |t|
      t.references :monero_invoice, foreign_key: true
      t.references :monero_wallet, foreign_key: true
      t.integer :payment_id
      t.string :amount
      t.string :tx_hash
      t.integer :height
      t.integer :confirmations
      t.boolean :isConfirmed

      t.timestamps
    end
  end
end
