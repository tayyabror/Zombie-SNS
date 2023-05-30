# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ItemsController, type: :request do
  survivor1 = Survivor.create(
    name: 'John Doe',
    age: 25,
    gender: 'Male',
    latitude: -80,
    longitude: 150
  )

  survivor2 = Survivor.create(
    name: 'adam lee',
    age: 23,
    gender: 'Male',
    latitude: -80,
    longitude: 150,
    reported_by: [12, 14, 54, 67]
  )

  item1 = InventoryItem.create(name: 'Fiji Water', points: 14)
  item2 = InventoryItem.create(name: 'Campbell Soup', points: 12)
  item3 = InventoryItem.create(name: 'First Aid Pouch', points: 10)
  item4 = InventoryItem.create(name: 'AK47', points: 8)

  survivor1.survivor_inventory_items.create(inventory_item_id: item1.id, quantity: 10)
  survivor1.survivor_inventory_items.create(inventory_item_id: item3.id, quantity: 13)
  survivor2.survivor_inventory_items.create(inventory_item_id: item4.id, quantity: 17)
  survivor2.survivor_inventory_items.create(inventory_item_id: item2.id, quantity: 23)

  describe 'POST /api/items' do
    it 'creates a new item' do
      expect {
        post '/api/items', params: {
          inventory_item: {
            name: 'water',
            points: 14
          }
        }, as: :json
      }.to change(InventoryItem, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json_response['name']).to eq('water')
      expect(json_response['points']).to eq(14)
    end

    it 'returns an error if points are negative' do
      post '/api/items', params: {
        inventory_item: {
          name: 'water',
          points: -1
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['points']).to include('must be greater than or equal to 0')
    end
  end

  describe 'PATCH /api/items/:id' do
    it 'updates an item' do

      patch "/api/items/#{item1.id}", params: {
        inventory_item: {
          name: 'water',
          points: 14
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response['name']).to eq('water')
    end
  end

  describe 'GET /api/items' do
    it 'returns all items' do

      get '/api/items', as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response.pluck('id')).to include(item1.id)
      expect(json_response.pluck('id')).to include(item2.id)
    end
  end

  describe 'DELETE /api/items/:id' do
    it 'destroys an item' do
      delete "/api/items/#{item1.id}", as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Item is destroyed')
    end
  end

  describe 'POST /api/items/trade' do
    it 'trades items between two survivors' do

      post '/api/items/trade', params: {
        survivor1_id: survivor1.id,
        survivor2_id: survivor2.id,
        survivor1_items: [{ item_id: item1.id, quantity: 5 }, { item_id: item3.id, quantity: 5 }],
        survivor2_items: [{ item_id: item4.id, quantity: 6 }, { item_id: item2.id, quantity: 6 }]
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Trade successful')

      expect(survivor1.survivor_inventory_items.find_by(inventory_item_id: item1.id).quantity).to eq(5)
      expect(survivor1.survivor_inventory_items.find_by(inventory_item_id: item3.id).quantity).to eq(8)
      expect(survivor1.survivor_inventory_items.find_by(inventory_item_id: item4.id).quantity).to eq(6)
      expect(survivor1.survivor_inventory_items.find_by(inventory_item_id: item2.id).quantity).to eq(6)

      expect(survivor2.survivor_inventory_items.find_by(inventory_item_id: item1.id).quantity).to eq(5)
      expect(survivor2.survivor_inventory_items.find_by(inventory_item_id: item3.id).quantity).to eq(5)
      expect(survivor2.survivor_inventory_items.find_by(inventory_item_id: item4.id).quantity).to eq(11)
      expect(survivor2.survivor_inventory_items.find_by(inventory_item_id: item2.id).quantity).to eq(17)
    end

    it 'fails to trade if total points are not equal' do
      post '/api/items/trade', params: {
        survivor1_id: survivor1.id,
        survivor2_id: survivor2.id,
        survivor1_items: [{ item_id: item1.id, quantity: 5 }, { item_id: item3.id, quantity: 6 }],
        survivor2_items: [{ item_id: item4.id, quantity: 6 }, { item_id: item2.id, quantity: 6 }]
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['error']).to eq('Total points of items are not equal. Trade cannot be performed.')
    end

    it 'fails to trade if one user is infected' do
      survivor1.update(reported_by: [12, 15, 19, 98, 31])

      post '/api/items/trade', params: {
        survivor1_id: survivor1.id,
        survivor2_id: survivor2.id,
        survivor1_items: [{ item_id: item1.id, quantity: 5 }, { item_id: item3.id, quantity: 5 }],
        survivor2_items: [{ item_id: item4.id, quantity: 6 }, { item_id: item2.id, quantity: 6 }]
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['error']).to eq("The trade is off due to #{survivor1.name} being infected.")
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
