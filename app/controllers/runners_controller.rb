class RunnersController < ApplicationController
  def create
    if user_signed_in?
      user_id = current_user.id
      race_id = runner_params
      create_runner = { user_id: user_id, race_id: race_id }
      @runner = Runner.new(create_runner)
      redirect_to :back
    else
      redirect_to new_user_session
    end
  end

  private

  def runner_params
    params.require(:runners).permit(:race_id)
  end
end
