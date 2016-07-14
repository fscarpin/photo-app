module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    # title = "#{title} <i class='#{direction == "desc" ? "fa fa-arrow-down" : "fa fa-arrow-up"}'></i>".html_safe
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
end






