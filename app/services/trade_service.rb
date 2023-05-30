# frozen_string_literal: true

# functionality trading items b/w survivors is written here
class TradeService
  def initialize(params)
    @survivor1 = Survivor.find_by_id(params[:survivor1_id])
    @survivor2 = Survivor.find_by_id(params[:survivor2_id])
    @survivor1_items = params[:survivor1_items]
    @survivor2_items = params[:survivor2_items]
  end

  def perform
    if check_infected.present?
      check_infected
    elsif total_points(@survivor1_items) == total_points(@survivor2_items)
      trading
      { message: 'Trade successful' }
    else
      { error: 'Total points of items are not equal. Trade cannot be performed.' }
    end
  end

  def trading
    ActiveRecord::Base.transaction do
      trade_items(@survivor1_items, @survivor2_items, @survivor1)
      trade_items(@survivor2_items, @survivor1_items, @survivor2)
    end
  end

  def check_infected
    return false unless @survivor1.infected || @survivor2.infected

    { error: "The trade is off due to #{@survivor1.infected ? @survivor1.name : @survivor2.name} being infected." }
  end

  def total_points(items_array)
    total_points = 0
    items_array.each do |i|
      inventory_item = InventoryItem.find(i[:item_id])
      total_points += i[:quantity] * inventory_item.points
    end

    total_points
  end

  def trade_items(remove_items, add_items, survivor)
    remove_items(remove_items, survivor)
    add_items(add_items, survivor)
  end

  def remove_items(remove_items, survivor)
    remove_items.each do |i|
      inventory_item = InventoryItem.find(i[:item_id])
      survivor_inventory_item = survivor.survivor_inventory_items.find_by(inventory_item_id: inventory_item.id)
      survivor_inventory_item.quantity -= i[:quantity]
      if survivor_inventory_item.quantity.zero?
        survivor_inventory_item.destroy
      else
        survivor_inventory_item.save
      end
    end
  end

  def add_items(add_items, survivor)
    add_items.each do |i|
      inventory_item = InventoryItem.find(i[:item_id])
      survivor_inventory_item = survivor.survivor_inventory_items.find_by(inventory_item_id: inventory_item.id)
      if survivor_inventory_item.present?
        survivor_inventory_item.quantity += i[:quantity]
        survivor_inventory_item.save
      else
        survivor.survivor_inventory_items.create(inventory_item_id: inventory_item.id, quantity: i[:quantity])
      end
    end
  end
end
