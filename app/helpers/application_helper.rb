module ApplicationHelper

  def nav_item_class(path)
    'active' if current_page?(path)
  end

end
