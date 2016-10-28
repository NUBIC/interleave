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
      when 'Death'
        @breadcrumbs << { name: "#{options[:datapoint].domain_id}", url: interleave_registry_interleave_person_deaths_url(@registry, @interleave_person, datapoint_id: @datapoint.id), class: 'datapoint_link' }
      when 'Drug'
        @breadcrumbs << { name: "#{options[:datapoint].domain_id}:#{options[:datapoint].name}", url: interleave_registry_interleave_person_drug_exposures_url(@registry, @interleave_person, datapoint_id: @datapoint.id), class: 'datapoint_link' }
      when 'Measurement'
        @breadcrumbs << { name: "#{options[:datapoint].domain_id}:#{options[:datapoint].name}", url: interleave_registry_interleave_person_measurements_url(@registry, @interleave_person, datapoint_id: @datapoint.id), class: 'datapoint_link' }
      when 'Observation'
        @breadcrumbs << { name: "#{options[:datapoint].domain_id}:#{options[:datapoint].group_name}", url: interleave_registry_interleave_person_observations_url(@registry, @interleave_person, datapoint_id: @datapoint.id), class: 'datapoint_link' }
      when 'Procedure'
        @breadcrumbs << { name: "#{options[:datapoint].domain_id}:#{options[:datapoint].name}", url: interleave_registry_interleave_person_procedure_occurrences_url(@registry, @interleave_person, datapoint_id: @datapoint.id), class: 'datapoint_link' }
      end
    end
  end

  def load_concepts(column)
    @datapoint.concept_values(column).map { |concept| [concept.concept_name, concept.concept_id] }
  end

  def load_interleave_registry
    @registry = InterleaveRegistry.find(params[:interleave_registry_id])
  end

  def load_interleave_person
    @interleave_person = InterleavePerson.find(params[:interleave_person_id])
  end

  def load_interleave_datapoint
    @datapoint = InterleaveDatapoint.find(params[:datapoint_id])
  end
end