class CreateFeatures < ActiveRecord::Migration[7.1]
  def change
    create_table :features do |t|
      t.string :external_id
      t.string :type

      t.string :magnitude
      t.string :mag_type
      t.string :place
      t.string :time
      t.string :url
      t.string :tsunami
      t.string :title

      t.decimal :longitude, precision: 20, scale: 17
      t.decimal :latitude, precision: 20, scale: 17

      t.timestamps
    end
  end
end
