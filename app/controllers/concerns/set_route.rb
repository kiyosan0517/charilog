module SetRoute
  def save_route
    if params[:post][:end_latitude].present?
      Route.create(
        start_latitude: params[:post][:start_latitude],
        start_longitude: params[:post][:start_longitude],
        waypoint_latitude: params[:post][:waypoint_latitude],
        waypoint_longitude: params[:post][:waypoint_longitude],
        waypoint1_latitude: params[:post][:waypoint1_latitude],
        waypoint1_longitude: params[:post][:waypoint1_longitude],
        waypoint2_latitude: params[:post][:waypoint2_latitude],
        waypoint2_longitude: params[:post][:waypoint2_longitude],
        end_latitude: params[:post][:end_latitude],
        end_longitude: params[:post][:end_longitude],
        post_id: @post.id
      )
    end
  end
end