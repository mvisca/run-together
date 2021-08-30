class AddColumnToRace < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :race_datetime, :datetime
  end
end
