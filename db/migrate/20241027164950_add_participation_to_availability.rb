class AddParticipationToAvailability < ActiveRecord::Migration[7.1]
  def change
    add_reference :availabilities, :participation, null: false, foreign_key: true
  end
end
