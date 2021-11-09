class CreateIntros < ActiveRecord::Migration[6.1]
  def change
    create_table :intros do |t|
      t.text :about
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
