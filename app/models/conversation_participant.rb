class ConversationParticipant < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  def mark_as_read!
    update!(last_read_at: Time.current)
  end

  def unread_messages_count
    scope = conversation.messages.where.not(user_id: user_id)
    scope = scope.where("created_at > ?", last_read_at) if last_read_at
    scope.count
  end
end
