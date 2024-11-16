class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, counter_cache: true

  validates :user_id, uniqueness: { scope: [:votable_type, :votable_id], 
    message: "has already voted for this item" }
end
