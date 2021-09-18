class ProfileController < ApplicationController
  def index
    @user = current_user
    @this_race = Race.new
  end
end
