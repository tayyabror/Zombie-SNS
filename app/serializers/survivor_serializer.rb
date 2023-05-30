# frozen_string_literal: true

# serialize survivor object here
class SurvivorSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender, :latitude, :longitude, :reported_by

  has_many :survivor_inventory_items
end