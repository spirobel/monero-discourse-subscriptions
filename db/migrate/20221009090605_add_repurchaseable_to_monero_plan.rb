class AddRepurchaseableToMoneroPlan < ActiveRecord::Migration[7.0]
  def change
    add_column :monero_plans, :repurchaseable, :boolean
  end
end
