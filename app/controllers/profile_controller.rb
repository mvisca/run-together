class ProfileController < ApplicationController
  def index
    @user = current_user
    @my_races = Race.where(user_id: @user.id)
    @optin_races = set_choice_races
    @race = Race.new
    @full_name = set_full_name
    @hidden_email = hide_email
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

  def set_full_name
    @user
      .name
      .split(' ')
      .map { |name_part| name_part.capitalize }
      .join(' ')
  end

  def hide_email
    email = @user.email.split('@')
    email_name = met1(email[0])
    email_domain = met1(email[1])
    "#{email_name}@#{email_domain}"
  end

  def met1(string_rt)
    string_rt
      .split('.')
      .map { |word| hide_chars(word) }
      .join('.')
  end

  def hide_chars(string)
    result = "*" * string.length
    i = -2
    2.times do
      result[i] = string.chars[i] if string.length > i * -1
      i += 1
    end
    result
  end
end

