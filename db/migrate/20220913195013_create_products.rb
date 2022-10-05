class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :monero_products do |t|
      t.string :name
      t.text :description
      t.boolean :active
      t.integer :position
      t.references :group, foreign_key: true
      t.references :monero_wallet, foreign_key: true


      t.timestamps
    end
  end
end
