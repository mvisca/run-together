class CreateRaces < ActiveRecord::Migration[6.1]
  def change
    create_table :races do |t|
      t.string :name
      t.integer :length
      t.string :meet_point
      t.time :run_time

      t.timestamps
    end
  end
end
