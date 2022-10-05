class CreateMoneroSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :monero_subscriptions do |t|
      t.references :monero_invoice, foreign_key: true
      t.datetime :end
      t.boolean :ended

      t.timestamps
    end
  end
end
