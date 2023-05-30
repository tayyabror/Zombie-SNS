class CreateSurvivorInventoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :survivor_inventory_items do |t|
      t.references :survivor, foreign_key: true
      t.references :inventory_item, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
