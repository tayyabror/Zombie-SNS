# frozen_string_literal: true

module Api
  # survivor api's
  class SurvivorsController < ApplicationController
    before_action :set_survivor, only: %i[show update destroy reported_infected_survivor]
    before_action :set_infected_survivor, only: %i[reported_infected_survivor]

    def index
      @survivors = Survivor.all
      render json: @survivors
    end

    def show
      render json: @survivor, include: :inventory_items
    end

    def create
      @survivor = Survivor.new(survivor_params)

      if @survivor.save
        render json: @survivor, status: :created
      else
        render json: @survivor.errors, status: :unprocessable_entity
      end
    end

    def update
      if @survivor.update(survivor_params)
        render json: @survivor
      else
        render json: @survivor.errors, status: :unprocessable_entity
      end
    end

    def destroy
      if @survivor.destroy
        render json: { message: 'Survivor is destroyed' }
      else
        render json: @survivor.errors, status: :unprocessable_entity
      end
    end

    def reported_infected_survivor
      @infected_survivor.reported_by << @survivor.id

      if @infected_survivor&.save
        render json: { message: 'Survivor is reported as infected' }
      else
        render json: @infected_survivor.errors, status: :unprocessable_entity
      end
    end

    private

    def set_survivor
      unless  @survivor = Survivor.find_by_id(params[:id])
        render json: { error: 'Survivor not found' }, status: :not_found 
      end
    end

    def set_infected_survivor
      unless  @infected_survivor = Survivor.find_by_id(params[:infected_user_id])
        render json: { error: 'Survivor not found' }, status: :not_found 
      end
    end

    def survivor_params
      params.require(:survivor).permit(
        :name, :age, :gender, :latitude, :longitude,
        survivor_inventory_items_attributes: %i[id inventory_item_id quantity]
      )
    end
  end
end
