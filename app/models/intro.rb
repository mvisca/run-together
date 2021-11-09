class Intro < ApplicationRecord
  belongs_to :user
  validates :about, length: { maximum: 220}
end
