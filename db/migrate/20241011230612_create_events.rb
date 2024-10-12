class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :title, null: false
      t.text :description
      t.string :category
      t.string :location
      t.jsonb :weather_data
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
