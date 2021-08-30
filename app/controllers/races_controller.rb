class RacesController < ApplicationController

  def index
    @races = Race.all
  end

  def new
    @now = DateTime.now.strftime("%d %b of %Y, %H:%M")
  end

  def create
    @race = params
  end

end
