class Race < ApplicationRecord
  validates :name, presence: true, length: { maximum: 25}
  validates :length, presence: true, numericality: { only_integer: true }
  validates :meet_point, presence: true
  validates :race_datetime, presence: true
end
