# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      inventory_item = InventoryItem.new(
        name: 'Fiji Water',
        points: 14
      )
      expect(inventory_item).to be_valid
    end

    it 'is invalid without a name' do
      inventory_item = InventoryItem.new(
        points: 14
      )
      expect(inventory_item).not_to be_valid
      expect(inventory_item.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without points' do
      inventory_item = InventoryItem.new(
        name: 'Fiji Water'
      )
      expect(inventory_item).not_to be_valid
      expect(inventory_item.errors[:points]).to include("can't be blank")
    end
  end
end
