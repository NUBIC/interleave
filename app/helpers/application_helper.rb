module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge({sort: column, direction: direction}), { class: css_class }
  end

  def tab_selected?(controller, action)
    selected = nil
    if params[:controller] == controller && params[:action] == action
      selected = true
    else
      selected = false
    end
    selected
  end
end
