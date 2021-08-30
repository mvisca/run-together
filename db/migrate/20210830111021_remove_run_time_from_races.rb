class RemoveRunTimeFromRaces < ActiveRecord::Migration[6.1]
  def change
    remove_column :races, :run_time, :time
  end
end
