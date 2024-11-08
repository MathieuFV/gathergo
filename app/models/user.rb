class User < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :availabilities, through: :participations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_one_attached :photo

  has_many :trips, through: :participations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :address, presence: true

  # Geocoding
  geocoded_by :address

  after_validation :geocode, if: :will_save_change_to_address?
  def voted_for?(votable)
    votes.exists?(votable: votable)
  end
end
