# frozen_string_literal: true
class MoneroProduct < ActiveRecord::Base
    has_many :monero_plans,  -> { includes :monero_product }, class_name: "MoneroPlan", :foreign_key => "monero_product_id",inverse_of: "monero_product", autosave: true, dependent: :destroy
    belongs_to :monero_wallet
    belongs_to :group
end