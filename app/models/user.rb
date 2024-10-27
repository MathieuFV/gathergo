class User < ApplicationRecord
  has_many :participations, dependent: :destroy
  has_many :availabilities, through: :participations, dependent: :destroy

  has_many :trips, through: :participations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
