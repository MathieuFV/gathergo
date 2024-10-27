class Trip < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  has_many :trip_destinations, dependent: :destroy
  has_many :destinations, through: :trip_destinations, dependent: :destroy
end
