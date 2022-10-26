class AddBeginDateToMoneroSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :monero_subscriptions, :begin_date, :datetime
  end
end
