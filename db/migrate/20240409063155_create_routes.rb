class CreateRoutes < ActiveRecord::Migration[6.0]
  def change
    create_table :routes do |t|
      t.references :post, null: false, foreign_key: true
      t.float :start_latitude
      t.float :start_longitude
      t.float :waypoint_latitude
      t.float :waypoint_longitude
      t.float :end_latitude
      t.float :end_longitude

      t.timestamps
    end
  end
end
