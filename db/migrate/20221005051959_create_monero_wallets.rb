class CreateMoneroWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :monero_wallets do |t|
      t.string :name
      t.string :primaryAddress
      t.string :privateViewKey
      t.integer :restoreHeight
      t.boolean :stagenet

      t.timestamps
    end
  end
end
