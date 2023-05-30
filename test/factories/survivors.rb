FactoryBot.define do
  factory :survivor do
    name { "John Doe" }
    age { 25 }
    gender { "Male" }
    latitude { 76.34 }
    longitude { 129.33 }

    # transient do
    #   inventory_items_count { 3 }
    # end

    # after(:create) do |survivor, evaluator|
    #   create_list(:inventory_item, evaluator.inventory_items_count, survivor: survivor)
    # end
  end
end