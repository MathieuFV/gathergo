class Destination < ApplicationRecord
  belongs_to :trip
  belongs_to :owner, class_name: 'User'

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :trip_id, presence: true
  validates :name, presence: true

  has_many_attached :photos, dependent: :purge

  # Geocoding
  geocoded_by :name
  after_validation :geocode, if: :will_save_change_to_name?

  def voted_by?(user)
    votes.exists?(user: user)
  end
end
