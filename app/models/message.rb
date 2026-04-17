class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :body, presence: true

  after_create_commit :broadcast_to_conversation

  private

  def broadcast_to_conversation
    ActionCable.server.broadcast(
      "conversation_#{conversation_id}",
      {
        id: id,
        body: body,
        user_id: user_id,
        user_name: user.name,
        avatar_url: user.photo.attached? ? Rails.application.routes.url_helpers.url_for(user.photo) : nil,
        created_at: created_at.strftime("%d %b, %H:%M")
      }
    )
  end
end
