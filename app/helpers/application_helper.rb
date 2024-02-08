module ApplicationHelper
  def nav_item_class(path)
    'active' if current_page?(path)
  end

  def search_from?
    params[:q].present?
  end

  def service_detail(icon_class, title, description, additional_note = nil)
    content_tag(:div, class: "col-lg-4 col-sm-6") do
      content_tag(:div, class: "service card-effect") do
        content_tag(:div, class: "d-flex #{additional_note.present? ? 'flex-wrap ' : ''}align-items-center mt-4") do
          concat(content_tag(:i, nil, class: icon_class + " mb-2 me-1"))
          concat(content_tag(:h5, title, class: "fw-bold"))
          concat(content_tag(:h6, additional_note)) if additional_note.present?
        end +
        content_tag(:p, description)
      end
    end
  end

  def footer_nav_link(path, icon_name, title)
    content_tag(:div, class: "col-2 p-0 text-center") do
      link_to path, style: "text-decoration:none;" do
        content_tag(:div, class: "text-white") do
          content_tag(:div, class: "h5 m-0") do
            tag.ion_icon(name: icon_name)
          end +
          content_tag(:div, title, class: "title font-mini-size")
        end
      end
    end
  end
end
