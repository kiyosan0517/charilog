module ServiceDetailHelper 
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
end