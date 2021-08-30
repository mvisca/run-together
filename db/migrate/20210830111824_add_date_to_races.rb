class AddDateToRaces < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :run_time, :time
  end
end
