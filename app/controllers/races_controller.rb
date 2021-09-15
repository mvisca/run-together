class RacesController < ApplicationController
  before_action :find_race, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @races = Race.all.sort { |a, b| a.race_datetime <=> b.race_datetime }
  end

  def show
    @created_time = Time.now.strftime("%A #{Time.now.day.ordinalize} of %B, %Y")
    @this_race = Race.new
  end

  def new
    @race = Race.new
  end

  def create
    @race = Race.new(race_params)
    @race.public = true
    if @race.save
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
    params.require(:race).permit(:name, :description, :length, :meet_point, :race_datetime)
  end

  def find_race
    @race = Race.find(params[:id])
  end
end
