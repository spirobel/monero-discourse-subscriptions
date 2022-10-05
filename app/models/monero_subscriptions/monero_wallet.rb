class MoneroWallet < ApplicationRecord
    has_many :monero_products
    has_many :monero_payments
end
