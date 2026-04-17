class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :authorize_participant!

  def create
    @message = @conversation.messages.build(body: params[:body], user: current_user)
    if @message.save
      head :ok
    else
      render json: { error: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @race = Race.find(params[:race_id])
    @conversation = @race.conversation
  end

  def authorize_participant!
    is_runner = @race.runners.exists?(user: current_user)
    is_owner  = @race.user == current_user
    head :forbidden unless is_runner || is_owner
  end
end
