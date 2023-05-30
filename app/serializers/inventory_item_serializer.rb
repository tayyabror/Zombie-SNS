# frozen_string_literal: true

# serialize survivor object here
class InventoryItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :points
end