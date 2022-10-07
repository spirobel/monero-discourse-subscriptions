class MoneroWallet < ActiveRecord::Base
    has_many :monero_products
    has_many :monero_payments
end