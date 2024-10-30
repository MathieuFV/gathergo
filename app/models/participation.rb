class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  has_many :availabilities, dependent: :destroy

  validates :user_id, presence: true, uniqueness: { scope: :trip_id }
  validates :trip_id, presence: true
  validates :role, presence: true, inclusion: { in: ["admin", "participant"] }
end
