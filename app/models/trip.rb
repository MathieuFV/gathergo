class Trip < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :users, through: :participations
  has_many :destinations, dependent: :destroy

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true, comparison: { greater_than: :start_date}
end
