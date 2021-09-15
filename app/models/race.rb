class Race < ApplicationRecord
  validates :name, presence: true, length: { maximum: 25}, uniqueness: true
  validates :length, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :meet_point, presence: true
  validates :start_time, presence: true
  validates :description, presence: true
end
