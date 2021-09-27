class CreateRaces < ActiveRecord::Migration[6.1]
  def change
    create_table :races do |t|
      t.string :name
      t.text :description
      t.integer :length
      t.string :meet_point
      t.datetime :start_date
      t.boolean :public, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
