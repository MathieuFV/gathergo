class AddOwnerToDestinations < ActiveRecord::Migration[7.1]
  def change
    add_reference :destinations, :owner, null: false, foreign_key: { to_table: :users }
  end
end
