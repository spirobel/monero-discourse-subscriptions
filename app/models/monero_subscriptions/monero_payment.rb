class MoneroPayment < ActiveRecord::Base
    belongs_to :monero_invoice
    belongs_to :monero_wallet
end
