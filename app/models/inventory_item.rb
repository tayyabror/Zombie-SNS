# frozen_string_literal: true

# write inventory item models functionality here
class InventoryItem < ApplicationRecord
  has_many :survivor_inventory_items, dependent: :destroy
  has_many :survivors, through: :survivor_inventory_items

  validates :name, :points, presence: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }
end
