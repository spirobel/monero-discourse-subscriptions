class MoneroInvoice < ActiveRecord::Base
  has_many :monero_payments,  -> { includes :monero_invoice }, class_name: "MoneroPayment", :foreign_key => "monero_invoice_id",inverse_of: "monero_invoice"
  has_one :monero_subscriptions
  
  belongs_to :monero_plan
  belongs_to :buyer, class_name: "User"
  belongs_to :recipient, class_name: "User"
end
