class Destination < ApplicationRecord
  belongs_to :trip

  validates :trip_id, presence: true
  validates :name, presence: true
end
