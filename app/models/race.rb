class Race < ApplicationRecord
  validates :name, presence: true, length: { maximum: 25}, uniqueness: true
  validates :length, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :meet_point, presence: true
  validates :start_date, presence: true
  validates :description, presence: true

  has_many :runners, dependent: :destroy
  belongs_to :user
  has_one :conversation, dependent: :destroy

  after_create :create_conversation_with_owner

  geocoded_by :meet_point
  after_validation :geocode, if: :will_save_change_to_meet_point?

  private

  def create_conversation_with_owner
    conversation = create_conversation!
    conversation.conversation_participants.create!(user: user)
  end
end
