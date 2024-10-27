class RemoveUserAndTripFromAvailability < ActiveRecord::Migration[7.1]
  def change
    remove_reference :availabilities, :user, null: false, foreign_key: true
    remove_reference :availabilities, :trip, null: false, foreign_key: true
  end
end
