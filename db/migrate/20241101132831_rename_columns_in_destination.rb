class RenameColumnsInDestination < ActiveRecord::Migration[7.1]
  def change
    rename_column :destinations, :lat, :latitude
    rename_column :destinations, :lon, :longitude
  end
end
