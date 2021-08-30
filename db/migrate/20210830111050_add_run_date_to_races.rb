class AddRunDateToRaces < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :run_date, :date
  end
end
