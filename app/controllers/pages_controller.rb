class PagesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:home, :contact]

  def home
    @races = Race.all.order("start_date ASC")
    @markers = @races.geocoded.map do |race|
      {
        name: race.name,
        distance: race.length,
        runners_count: race.runners.count,
        meet_point: race.meet_point,
        date: race.start_date.strftime("%d %b %Y, %H:%M"),
        lng: race.longitude,
        lat: race.latitude,
        creator_name: race.user.name.split.first.capitalize,
        creator_avatar: race.user.avatar_url(size: 150),
        url: race_path(race)
      }
    end
  end


end
