class CreateDestinations < ActiveRecord::Migration[7.1]
  def change
    create_table :destinations do |t|
      t.string :name
      t.decimal :lon
      t.decimal :lat

      t.timestamps
    end
  end
end
