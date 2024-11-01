class Destination < ApplicationRecord
  belongs_to :trip

  validates :trip_id, presence: true
  validates :name, presence: true

  # Geocoding
  geocoded_by :name

  after_validation :geocode, if: :will_save_change_to_name?
end
