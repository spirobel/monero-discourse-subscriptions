class CreateMoneroPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :monero_plans do |t|
      t.string :currency
      t.string :amount
      t.references :monero_product, foreign_key: true
      t.integer :duration
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end
end
