class AddWaypointsToRoutes < ActiveRecord::Migration[6.0]
  def change
    add_column :routes, :waypoint1_latitude, :float, null: true
    add_column :routes, :waypoint1_longitude, :float, null: true
    add_column :routes, :waypoint2_latitude, :float, null: true
    add_column :routes, :waypoint2_longitude, :float, null: true
  end
end
