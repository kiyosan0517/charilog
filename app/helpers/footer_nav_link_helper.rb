module FooterNavLinkHelper
  def footer_nav_link(path, icon_name, title)
    content_tag(:div, class: 'col-2 p-0 text-center') do
      link_to path, style: 'text-decoration:none;' do
        content_tag(:div, class: 'text-white') do
          content_tag(:div, class: 'h5 m-0') {
            tag.ion_icon(name: icon_name)
          } +
          content_tag(:div, title, class: 'title font-mini-size')
        end
      end
    end
  end
end
