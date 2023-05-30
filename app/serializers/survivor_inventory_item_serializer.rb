# frozen_string_literal: true

# serialize survivor object here
class SurvivorInventoryItemSerializer < ActiveModel::Serializer
    attributes :id, :inventory_item_id, :quantity
end