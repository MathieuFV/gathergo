class AddDescriptionToDestination < ActiveRecord::Migration[7.1]
  def change
    add_column :destinations, :description, :text
  end
end
