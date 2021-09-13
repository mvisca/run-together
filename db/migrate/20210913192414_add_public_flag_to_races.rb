class AddPublicFlagToRaces < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :public, :boolean
  end
end
