class MoneroInvoice < ApplicationRecord
  has_many :monero_payments
  has_one :monero_subscriptions
  
  belongs_to :monero_plan
  belongs_to :buyer, class_name: "User"
  belongs_to :recipient, class_name: "User"
end
