class AddCallbackSecretToMoneroWallet < ActiveRecord::Migration[7.0]
  def change
    add_column :monero_wallets, :callbackSecret, :string
  end
end
