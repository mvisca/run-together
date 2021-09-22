class ProfileController < ApplicationController
  def index
    @user = current_user
    @this_race = Race.new
    @owned_races = Race.where(user_id: @user.id)
    @choice_races = set_choice_races
  end

  private

  def set_choice_races
    runner_opted_in = Runner.where(user_id: current_user.id)
    choice_races = []
    runner_opted_in.each do |runner|
      race = Race.find(runner.race_id)
      choice_races << race unless race.user_id == current_user.id
    end
    choice_races
  end

end

