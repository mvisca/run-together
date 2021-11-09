class IntrosController < ApplicationController
  before_action :find_intro, only: [ :edit, :update ]

  def new
    @about = Intro.new
  end

  def create
    @intro = Intro.new(intro_params)
    @intro.user_id = current_user.id

    if @intro.save
      redirect_to profile_index_path
    else
      render new_intro_path
    end
  end

  def edit
  end

  def update
    @intro.update(intro_params)
    if @intro.last.save
      redirect_to profile_index_path
    else
      render :edit
    end
  end

  private

    def intro_params
      params.require(:intro).permit(:about)
    end

    def find_intro
      @intro = Intro.where(user_id: current_user)
    end

end
