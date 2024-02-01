module ApplicationHelper
  def nav_item_class(path)
    'active' if current_page?(path)
  end

  def search_from?
    params[:q].present?
  end
end
