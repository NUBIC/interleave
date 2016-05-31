class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :breadcrumbs

  def breadcrumbs
    @breadcrumbs = []
  end

  def add_breadcrumbs(options = {})
    @breadcrumbs << { name: 'Registries', url: interleave_registries_url }

    if options[:registry]
      @breadcrumbs << { name: "#{options[:registry].name}", url: interleave_registry_interleave_people_url(options[:registry]) }
    end

    if options[:interleave_person]
      @breadcrumbs << { name: "#{options[:interleave_person].full_name}", url: details_interleave_registry_interleave_person_url(options[:registry], options[:interleave_person]) }
    end

    if options[:datapoint]
      case options[:datapoint].domain_id
      when 'Condition'
        @breadcrumbs << { name: "#{options[:datapoint].domain_id}:#{options[:datapoint].name}", url: interleave_registry_interleave_person_condition_occurrences_url(@registry, @interleave_person, datapoint_id: @datapoint.id) }
      end
    end
  end
end
