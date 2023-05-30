# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::SurvivorsController, type: :request do
  describe 'POST /api/survivors' do
    it 'creates a new survivor' do
      inventory_item = InventoryItem.create(name: 'water', points: 14)
      inventory_item_2 = InventoryItem.create(name: 'Campbell Soup', points: 12)

      expect {
        post '/api/survivors', params: {
          survivor: {
            name: 'John Doe',
            age: 25,
            gender: 'Male',
            latitude: 37.7749,
            longitude: -122.4194,
            survivor_inventory_items_attributes: [
              { inventory_item_id: inventory_item.id, quantity: 5 },
              { inventory_item_id: inventory_item_2.id, quantity: 3 }
            ]
          }
        }, as: :json
      }.to change(Survivor, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json_response['name']).to eq('John Doe')
    end
  end

  describe 'POST /api/survivors' do
    it 'returns validation errors for invalid survivor creation' do
      post '/api/survivors', params: {
        survivor: {
          name: '',
          age: 17,
          gender: 'Invalid',
          latitude: 91,
          longitude: 181,
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['name']).to include("can't be blank")
    end
  end

  describe 'PATCH /api/survivors/:id' do
    it "updates survivor's location" do
      survivor = Survivor.create(
        name: 'John Doe',
        age: 25,
        gender: 'Male',
        latitude: -80,
        longitude: 150
      )

      patch "/api/survivors/#{survivor.id}", params: {
        survivor: {
          latitude: 37.7749,
          longitude: -122.4194
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response['latitude']).to eq(37.7749)
      expect(json_response['longitude']).to eq(-122.4194)
    end
  end

  describe 'PATCH /api/survivors/:id' do
    it 'returns validation errors for invalid survivor location update' do
      survivor = Survivor.create(
        name: 'John Doe',
        age: 25,
        gender: 'Male',
        latitude: -80,
        longitude: 150
      )

      patch "/api/survivors/#{survivor.id}", params: {
        survivor: {
          latitude: 91,
          longitude: 181
        }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['latitude']).to include("must be less than or equal to 90")
      expect(json_response['longitude']).to include("must be less than or equal to 180")
    end
  end

  describe 'POST /api/survivors/:id/reported_infected_survivor' do
    it 'reports survivor as infected' do
      survivor = Survivor.create(
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
        longitude: 150
      )

      post "/api/survivors/#{survivor.id}/reported_infected_survivor", params: {
        infected_user_id: survivor2.id
      }, as: :json

      survivor2.reload

      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Survivor is reported as infected')
      expect(survivor2.reported_by).to include(survivor.id)
      expect([nil, false]).to include(survivor2.infected)
    end
  end

  describe 'POST /api/survivors/:id/reported_infected_survivor' do
    it 'makes survivor infected if reported by five survivors' do
      survivor = Survivor.create(
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

      post "/api/survivors/#{survivor.id}/reported_infected_survivor", params: {
        infected_user_id: survivor2.id
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Survivor is reported as infected')
      expect(survivor2.reload.infected).to eq(true)
    end
  end

  describe 'DELETE /api/survivors/:id' do
    it 'destroys a survivor' do
      survivor = Survivor.create(
        name: 'John Doe',
        age: 25,
        gender: 'Male',
        latitude: -80,
        longitude: 150
      )

      delete "/api/survivors/#{survivor.id}", as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Survivor is destroyed')
    end
  end

  describe 'GET /api/survivors' do
    it 'returns all survivors' do
      survivor = Survivor.create(
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

      get '/api/survivors', as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response.pluck('id')).to include(survivor.id)
      expect(json_response.pluck('id')).to include(survivor2.id)
    end
  end

  # Add more test cases for other API endpoints

  def json_response
    JSON.parse(response.body)
  end
end
