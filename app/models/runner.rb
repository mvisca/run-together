class Runner < ApplicationRecord
  belongs_to :user
  belongs_to :race

  validates_uniqueness_of :user_id, scope: :race_id
end
