class AddInformationsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :address, :string
    add_column :users, :lat, :decimal
    add_column :users, :lon, :decimal
    add_column :users, :phone, :string
  end
end
