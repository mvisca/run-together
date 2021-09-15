class RenameRaceDatetimeToStartTime < ActiveRecord::Migration[6.1]
  def change
    rename_column :races, :race_datetime, :start_time
  end
end
