# frozen_string_literal: true
class MoneroProduct < ActiveRecord::Base
    has_many :monero_plans
    belongs_to :monero_wallet
    belongs_to :group
end