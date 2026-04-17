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
        message: ApplicationController.renderer.render(
          partial: "messages/message",
          locals: { message: self }
        )
      }
    )
  end
end
