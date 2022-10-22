class AddShouldSyncToMoneroWallet < ActiveRecord::Migration[7.0]
  def change
    add_column :monero_wallets, :shouldSync, :boolean, default: true
  end
end
