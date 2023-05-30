# frozen_string_literal: true

module Api
  # report api's
  class ReportsController < ApplicationController
    def generate_report
      render json: {
        percentage: {
          infected_survivors: percentage_of_infected_survivors,
          non_infected_survivors: percentage_of_non_infected_survivors_report
        },
        items: items_report,
        total_lost_points: lost_point
      }
    end

    private

    def percentage_of_infected_survivors
      total_survivors = Survivor.all
      infected_survivors = total_survivors.where(infected: true)
      get_percentage(infected_survivors.count, total_survivors.count)
    end

    def percentage_of_non_infected_survivors_report
      total_survivors = Survivor.all
      not_infected_survivors = total_survivors.where(infected: [false, nil])
      get_percentage(not_infected_survivors.count, total_survivors.count)
    end

    def get_percentage(numerator, denominator)
      (numerator.to_f / denominator) * 100
    end

    def items_report
      survivor_count = Survivor.all.count
      SurvivorInventoryItem.joins(:inventory_item)
                           .select("inventory_items.name as item_name,
                            SUM(quantity)/#{survivor_count.to_f} as avg_quantity")
                           .group('inventory_items.name')
    end

    def lost_point
      infected_survivor_ids = Survivor.where(infected: true).pluck(:id)
      SurvivorInventoryItem.joins(:inventory_item)
                           .where(survivor_id: infected_survivor_ids)
                           .sum('inventory_items.points * survivor_inventory_items.quantity')
    end
  end
end
