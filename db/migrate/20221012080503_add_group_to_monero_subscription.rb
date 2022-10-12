class AddGroupToMoneroSubscription < ActiveRecord::Migration[7.0]
  def change
    add_reference :monero_subscriptions, :group, foreign_key: true
  end
end
