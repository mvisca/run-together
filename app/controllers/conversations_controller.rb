class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :authorize_participant!

  def show
    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
    @message = Message.new
    @participant = @conversation.conversation_participants.find_by(user: current_user)
    @participant&.mark_as_read!
  end

  private

  def set_conversation
    @race = Race.find(params[:race_id])
    @conversation = @race.conversation
    redirect_to root_path, alert: "Chat no disponible." unless @conversation
  end

  def authorize_participant!
    is_runner = @race.runners.exists?(user: current_user)
    is_owner  = @race.user == current_user
    redirect_to root_path, alert: "No tenés acceso a este chat." unless is_runner || is_owner
  end
end
