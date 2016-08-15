module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge({sort: column, direction: direction}), { class: css_class }
  end

  def in_params?(query_string_parameters)
    if query_string_parameters
      params.dup.merge(query_string_parameters) == params
    else
      false
    end
  end

  def active?(css_class, controller, action, query_string_parameters = {})
    active = nil
    if params[:controller] == controller && params[:action] == action && in_params?(query_string_parameters)
      active = true
    else
      active = false
    end
    active ? css_class : ''
  end

  def links_to_datapoints(registry, interleave_person, domain_id)
    capture do
      registry.interleave_datapoints.select { |interleave_datapoint| interleave_datapoint.domain_id == domain_id && interleave_datapoint.interleave_datapoint_parent.nil? }.each do |datapoint|
        generate_datapoint_url(registry, interleave_person, datapoint, domain_id)
      end
    end
  end

  private
    def generate_datapoint_url(registry, interleave_person, datapoint, domain_id)
      case domain_id
      when 'Condition'
        haml_tag(:li, class: active?('active', 'condition_occurrences', 'index', 'datapoint_id' => datapoint.id.to_s)) do
          concat link_to datapoint.name, interleave_registry_interleave_person_condition_occurrences_url(registry, interleave_person, datapoint_id: datapoint.id), class: 'datapoint'
        end
      when 'Drug'
        haml_tag(:li, class: active?('active', 'drug_exposures', 'index', 'datapoint_id' => datapoint.id.to_s)) do
          concat link_to datapoint.name, interleave_registry_interleave_person_drug_exposures_url(registry, interleave_person, datapoint_id: datapoint.id), class: 'datapoint'
        end
      when 'Measurement'
        haml_tag(:li, class: active?('active', 'measurements', 'index', 'datapoint_id' => datapoint.id.to_s)) do
          concat link_to datapoint.name, interleave_registry_interleave_person_measurements_url(registry, interleave_person, datapoint_id: datapoint.id), class: 'datapoint'
        end
      when 'Procedure'
        haml_tag(:li, class: active?('active', 'procedure_occurrences', 'index', 'datapoint_id' => datapoint.id.to_s)) do
          concat link_to datapoint.name, interleave_registry_interleave_person_procedure_occurrences_url(registry, interleave_person, datapoint_id: datapoint.id)
        end
      end
    end
end