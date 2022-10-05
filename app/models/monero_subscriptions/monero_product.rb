# frozen_string_literal: true

module MoneroSubscriptions
    class MoneroProduct < ActiveRecord::Base
        has_many :monero_plans
        belongs_to :monero_wallet
        belongs_to :group
    end
end