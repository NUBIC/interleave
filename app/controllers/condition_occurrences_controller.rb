class ConditionOccurrencesController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_interleave_registry, only: [:index, :new, :create]
  before_filter :load_interleave_person, only: [:index, :new, :create]

  def index
    params[:page]||= 1
    options = {}
    options[:sort_column] = sort_column
    options[:sort_direction] = sort_direction
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    add_breadcrumbs(registry: @registry, interleave_person: @interleave_person, datapoint: @datapoint)
    @condition_occurrences = ConditionOccurrence.by_person(@interleave_person.person.person_id).by_interleave_data_point(@datapoint.id).paginate(per_page: 10, page: params[:page])
  end

  def new
    @datapoint = @registry.interleave_datapoints.find(params[:datapoint_id])
    @concepts = []
    @type_concepts = Concept.condition_types.valid.standard.map { |condition_type| [condition_type.concept_name, condition_type.concept_id] }
    @condition_occurrence = ConditionOccurrence.new()
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @condition_occurrence = ConditionOccurrence.new(condition_occurence_params)
    @condition_occurrence.interleave_registry_cdm_source = @registry.interleave_registry_cdm_sources.where(cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO).first
    @condition_occurrence.person = @interleave_person.person
    respond_to do |format|
      if @condition_occurrence.save
        format.js   {}
      else
        format.js   {}
      end
    end
  end

  private
    def condition_occurence_params
      params.require(:condition_occurrence).permit(:interleave_datapoint_id, :condition_concept_id, :condition_start_date, :condition_end_date, :condition_type_concept_id)
    end

    def load_interleave_registry
      @registry = InterleaveRegistry.find(params[:interleave_registry_id])
    end

    def load_interleave_person
      @interleave_person = InterleavePerson.find(params[:interleave_person_id])
    end

    def sort_column
      !params[:sort].blank? ? params[:sort] : 'condition_start_date'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
end