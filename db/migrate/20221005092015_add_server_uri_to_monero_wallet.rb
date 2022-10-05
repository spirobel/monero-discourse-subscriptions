class AddServerUriToMoneroWallet < ActiveRecord::Migration[7.0]
  def change
    add_column :monero_wallets, :serverUri, :string
    add_column :monero_wallets, :callback, :string
  end
end
