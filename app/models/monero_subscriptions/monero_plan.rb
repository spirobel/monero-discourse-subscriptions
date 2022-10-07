# frozen_string_literal: true
class MoneroPlan < ActiveRecord::Base
  has_many :monero_invoices
  belongs_to :monero_product
end



