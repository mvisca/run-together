class RacesController < ApplicationController
  before_action :find_race, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @races = Race.all
    @markers = @races.geocoded.map do |race|
      {
        lng: race.longitude,
        lat: race.latitude
        # info_window: render_to_string(partial: "info_window"
        # locals: { race: race }),
        # image_url: helpers.asset_url('logo')
      }
    end
  end

  def show
    @runners = Runner.where(race_id: params[:id])
    @runners_id = @runners.pluck(:user_id)
    @marker =
      {
        lng: @race.longitude,
        lat: @race.latitude
      }
  end

  def new
    @race = Race.new
  end

  def create
    @race = Race.new(race_params)
    @race.public = true # TODO: default in the model
    @race.user = current_user
    if @race.save
      Runner.create(race_id: @race.id, user_id: @race.user_id)
      redirect_to race_path(@race)
    else
      render new_race_path
    end
  end

  def edit
  end

  def update
    @race.update(race_params)
    if @race.save
      redirect_to race_path(@race)
    else
      render :edit
    end
  end

  def destroy
    @race.destroy
    redirect_to races_path
  end

  private

  def race_params
    params.require(:race).permit(:name, :description, :length, :meet_point, :start_date)
  end

  def find_race
    @race = Race.find(params[:id])
  end

  def set_races
    Race.all
    .sort { |a, b| a.start_date <=> b.start_date }
    .select{ |race| race.start_date > Time.now }
  end

end
