class Race < ApplicationRecord
  validates :name, presence: true, length: { maximum: 25}, uniqueness: true
  validates :length, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :meet_point, presence: true
  validates :start_date, presence: true
  validates :description, presence: true

  has_many :runners, dependent: :destroy
  belongs_to :user

  geocoded_by :meet_point
  after_validation :geocode, if: :will_save_change_to_meet_point?
end
