class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :breadcrumbs

  def breadcrumbs
    @breadcrumbs = []
  end

  def add_breadcrumbs(options = {})
    @breadcrumbs << { name: 'Registries', url: interleave_registries_url, class: 'registries_link' }

    if options[:registry]
      @breadcrumbs << { name: "#{options[:registry].name}", url: interleave_registry_interleave_people_url(options[:registry]), class: 'registry_link' }
    end

    if options[:interleave_person]
      @breadcrumbs << { name: "#{options[:interleave_person].full_name}", url: details_interleave_registry_interleave_person_url(options[:registry], options[:interleave_person]), class: 'person_link' }
    end

    if options[:datapoint]
      case options[:datapoint].domain_id
      when 'Condition'
        @breadcrumbs << { name: "#{options[:datapoint].domain_id}:#{options[:datapoint].name}", url: interleave_registry_interleave_person_condition_occurrences_url(@registry, @interleave_person, datapoint_id: @datapoint.id), class: 'datapoint_link' }
      end
    end
  end
end
