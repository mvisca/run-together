class AddCoordinatesToRaces < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :latitude, :float
    add_column :races, :longitude, :float
  end
end
