class CreateSurvivors < ActiveRecord::Migration[7.0]
  def change
    create_table :survivors do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.float :latitude
      t.float :longitude
      t.boolean :infected
      t.integer :reported_by, array: true, default: []

      t.timestamps
    end
  end
end
