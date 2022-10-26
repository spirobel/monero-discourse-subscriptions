# frozen_string_literal: true
class MoneroSubscription < ActiveRecord::Base
  belongs_to :monero_invoice
  
  belongs_to :monero_plan
  belongs_to :buyer, class_name: "User"
  belongs_to :recipient, class_name: "User"
  def buyer_name
    return buyer.username
  end
  def recipient_name
    return recipient.username
  end
end

