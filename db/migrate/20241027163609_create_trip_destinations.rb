class CreateTripDestinations < ActiveRecord::Migration[7.1]
  def change
    create_table :trip_destinations do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :destination, null: false, foreign_key: true

      t.timestamps
    end
  end
end
