# frozen_string_literal: true
class MoneroSubscription < ActiveRecord::Base
  belongs_to :monero_invoice
  belongs_to :group
end

