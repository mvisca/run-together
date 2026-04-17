class Conversation < ApplicationRecord
  belongs_to :race
  has_many :conversation_participants, dependent: :destroy
  has_many :users, through: :conversation_participants
  has_many :messages, dependent: :destroy

  def other_participants(current_user)
    users.where.not(id: current_user.id)
  end

  def last_message
    messages.order(created_at: :desc).first
  end
end
