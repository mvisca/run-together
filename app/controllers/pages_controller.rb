class PagesController < ApplicationController
  def home
    @now = Time.now.strftime("%I:%M %p, %d de %B, %Y.")
    # Generate Time string with https://strftimer.com/
  end

  def about
  end

  def contact
  end
end
