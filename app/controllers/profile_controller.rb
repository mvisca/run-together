class ProfileController < ApplicationController
  def index
    @user = current_user
    @my_races = Race.where(user_id: @user.id)
    @optin_races = set_choice_races


    #   @runners = Runner.where(race_id: params[:id])
    # @runners_id = @runners.pluck(:user_id)
    # @marker =
    #   {
    #     lat: @race.latitude,
    #     lng: @race.longitude
    #   }


  end

    def self.get_lat_lon
       { lat: self.latitude, lng: self.longitude }.to_json
    end

  private

  def set_choice_races
    runner_opted_in = Runner.where(user_id: @user.id)
    choice_races = []
    runner_opted_in.each do |runner|
      race = Race.find(runner.race_id)
      choice_races << race unless race.user_id == @user.id
    end
    choice_races
  end

end

