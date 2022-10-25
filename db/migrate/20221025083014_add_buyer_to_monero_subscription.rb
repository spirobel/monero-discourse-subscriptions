class AddBuyerToMoneroSubscription < ActiveRecord::Migration[7.0]
  def change
    add_reference :monero_subscriptions, :buyer, foreign_key: {to_table: :users}
    add_reference :monero_subscriptions, :recipient, foreign_key: {to_table: :users}
    add_reference :monero_subscriptions, :monero_plan, foreign_key: true
    #remove_column :monero_subscriptions, :group this should be in a post deployment migrateion, but we just wont bother and ignore the column
    add_column :monero_subscriptions, :currency, :string
    add_column :monero_subscriptions, :amount, :string


  end
end
