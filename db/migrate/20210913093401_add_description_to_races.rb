class AddDescriptionToRaces < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :description, :text
  end
end
