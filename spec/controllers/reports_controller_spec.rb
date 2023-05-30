# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::ReportsController', type: :request do
  describe 'GET /api/reports/generate_report' do
    it 'returns items report' do
      survivor1 = FactoryBot.create(:survivor, name: 'John Doe', age: 25, gender: 'Male', latitude: -80, longitude: 150)
      survivor2 = FactoryBot.create(:survivor, name: 'adam lee', age: 23, gender: 'Male', latitude: -80, longitude: 150, reported_by: [12, 14, 54, 67, 43, 56])
      item1 = FactoryBot.create(:inventory_item, name: 'Fiji Water', points: 14)
      item2 = FactoryBot.create(:inventory_item, name: 'Campbell Soup', points: 12)
      item3 = FactoryBot.create(:inventory_item, name: 'First Aid Pouch', points: 10)
      item4 = FactoryBot.create(:inventory_item, name: 'AK47', points: 8)

      FactoryBot.create(:survivor_inventory_item, survivor: survivor1, inventory_item: item1, quantity: 10)
      FactoryBot.create(:survivor_inventory_item, survivor: survivor1, inventory_item: item3, quantity: 13)
      FactoryBot.create(:survivor_inventory_item, survivor: survivor2, inventory_item: item4, quantity: 17)
      FactoryBot.create(:survivor_inventory_item, survivor: survivor2, inventory_item: item2, quantity: 23)
      FactoryBot.create(:survivor_inventory_item, survivor: survivor2, inventory_item: item1, quantity: 19)
      FactoryBot.create(:survivor_inventory_item, survivor: survivor2, inventory_item: item3, quantity: 33)
      FactoryBot.create(:survivor_inventory_item, survivor: survivor1, inventory_item: item4, quantity: 57)
      FactoryBot.create(:survivor_inventory_item, survivor: survivor1, inventory_item: item2, quantity: 3)

      get '/api/reports/generate_report', as: :json

      expect(response).to have_http_status(:ok)
      expect(json_response).to have_key('items')
      expect(json_response).to have_key('percentage')
      expect(json_response).to have_key('total_lost_points')
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
