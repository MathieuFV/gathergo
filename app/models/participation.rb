class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  has_many :availabilities, dependent: :destroy
end
