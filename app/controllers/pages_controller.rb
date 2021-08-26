class PagesController < ApplicationController
  def home
    @now = Time.now.strftime("%I:%M %p, %d de %B, %Y.")
    # Generate Time string with https://strftimer.com/
  end

  def about
  end

  def contact
  end

  def new_race
  end

  def race_details
    @data = params
  end

  # def searching
  #     search = paramas[:name]
  #     @restuls = if search.present? ? params[:name] : 'Not found'
  # end

  private

  def get_params
  end
end
