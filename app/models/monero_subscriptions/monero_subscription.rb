# frozen_string_literal: true
class MoneroSubscription < ActiveRecord::Base
  belongs_to :monero_invoice
  has_many :monero_payments, through: :monero_invoice
  belongs_to :monero_product
  belongs_to :monero_plan
  belongs_to :buyer, class_name: "User"
  belongs_to :recipient, class_name: "User"
  def buyer_name
    if buyer.nil?
      return nil
    end
    return buyer.username
  end
  def recipient_name
    if recipient.nil?
      return nil
    end
    return recipient.username
  end
  def product_name
    return monero_plan.monero_product.name
  end
  def duration
    return monero_plan.duration
  end
  def invoice
    return monero_invoice
  end
end

