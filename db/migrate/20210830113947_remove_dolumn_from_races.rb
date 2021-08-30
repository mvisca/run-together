class RemoveDolumnFromRaces < ActiveRecord::Migration[6.1]
  def change
    remove_column :races, :run_date, :date
  end
end
