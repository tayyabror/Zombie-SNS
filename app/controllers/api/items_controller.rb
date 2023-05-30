# frozen_string_literal: true

module Api
  # inventory item api's
  class ItemsController < ApplicationController
    before_action :set_item, only: %i[show update destroy]

    def index
      @items = InventoryItem.all
      render json: @items
    end

    def create
      @item = InventoryItem.new(item_params)

      if @item.save
        render json: @item, status: :created
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    def update
      if @item.update(item_params)
        render json: @item
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    def destroy
      if @item.destroy
        render json: { message: 'Item is destroyed' }
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    def trade
      trade_service = TradeService.new(params)
      result = trade_service.perform

      render json: result, status: result[:error] ? :unprocessable_entity : :ok
    end

    private

    def set_item
      unless @item = InventoryItem.find_by_id(params[:id])
        render json: { error: 'Item not found' }, status: :not_found
      end
    end

    def item_params
      params.require(:inventory_item).permit(:name, :points)
    end
  end
end
