# frozen_string_literal: true

module MoneroSubscriptions
  class MoneroSubscription < ActiveRecord::Base
    belongs_to :monero_invoice
  end
end
