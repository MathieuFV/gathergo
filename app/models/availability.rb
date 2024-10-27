class Availability < ApplicationRecord
  belongs_to :user
  belongs_to :trip
end
