class Availability < ApplicationRecord
  belongs_to :participation

  validates :participation_id, presence: true, uniqueness: { scope: [:start_date, :end_date] }
  validates :start_date, presence: true
  validates :end_date, presence: true, comparison: { greater_than_or_equal_to: :start_date }
end
