class RunnersController < ApplicationController
  before_action :authenticate_user!

  def create
    @race = Race.find(runner_params)
    if user_signed_in?
      user_id = current_user.id
      race_id = @race.id
      create_runner = { user_id: user_id, race_id: race_id }
      @runner = Runner.create(create_runner)
      redirect_to race_path(@race)
    else
      redirect_to new_user_session
    end
  end

  private

  def runner_params
    params.require(:runner).permit(:race_id)
  end

end

# TODO: delete this
