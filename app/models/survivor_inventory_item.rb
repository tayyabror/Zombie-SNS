# frozen_string_literal: true

# it is a bridge table for survivors and inventory_items
class SurvivorInventoryItem < ApplicationRecord
  belongs_to :survivor
  belongs_to :inventory_item

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
