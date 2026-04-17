class Runner < ApplicationRecord
  belongs_to :user
  belongs_to :race

  validates_uniqueness_of :user_id, scope: :race_id

  after_create :join_conversation
  after_destroy :leave_conversation

  private

  def join_conversation
    race.conversation&.conversation_participants&.find_or_create_by!(user: user)
  end

  def leave_conversation
    race.conversation&.conversation_participants&.find_by(user: user)&.destroy
  end
end
