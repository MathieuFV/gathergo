class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, counter_cache: true

  # Empêche un utilisateur de voter plusieurs fois pour la même chose
  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id] }
end
