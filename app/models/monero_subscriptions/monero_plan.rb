# frozen_string_literal: true
class MoneroPlan < ActiveRecord::Base
  has_many :monero_invoices
  belongs_to :monero_product
  attr_accessor :subscribed
  attr_accessor :can_purchase
  def stagenet
      return monero_product.monero_wallet.stagenet
  end
end



